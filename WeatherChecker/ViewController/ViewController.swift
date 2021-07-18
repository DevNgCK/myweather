//
//  ViewController.swift
//  WeatherChecker
//
//  Created by Gavin Ng on 17/7/2021.
//

import UIKit
import CoreLocation
import SDWebImage

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    var historyView = UITableView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var highestTemperature: UILabel!
    @IBOutlet weak var lowestTemperature: UILabel!
    
    
    var userLatitude: Double = 200.0
    var userLongitude: Double = 200.0
    
    var historyArray: NSArray = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        let userDefault = UserDefaults()
        if let cityName = userDefault.value(forKey: "cityName") as? String {
            OpenWeatherManager.getCurrentWeatherByCity(cityName) {(currentWeather) in
                self.checkCurrentWeatherDate(currentWeather)
            }
        }
        historyArray = userDefault.value(forKey: "historyName") as? NSArray ?? []
    }

    override func viewWillAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled()) {
            if (CLLocationManager.authorizationStatus() == .notDetermined) {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 50
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            } else if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 50
                locationManager.startUpdatingLocation()
            } else if (CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted) {
                self.showMessageDialog(title: "Warning", msg: "Please enable GPS function for \"Search By GPS\"", butMsg: "OK")
            }
        } else {
            self.showMessageDialog(title: "Error", msg: "Location service not enable", butMsg: "OK")
        }
    }

    func initialUI() {
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("searchBar.hints", comment: "")
                
        // Table View initial
        historyView = UITableView(frame: CGRect(x: searchBar.frame.minX, y: searchBar.frame.maxY + 10, width: searchBar.frame.width, height: UIScreen.main.bounds.size.height / 3))
        historyView.layer.cornerRadius = 5;
        historyView.layer.masksToBounds = true;
        
        historyView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        historyView.dataSource = self
        historyView.delegate = self
    }
    
    @IBAction func gpsClick(_ sender: Any) {
        if (CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted) {
            self.showMessageDialog(title: "Warning", msg: "Please enable GPS function for \"Search By GPS\"", butMsg: "OK")
        } else {
            OpenWeatherManager.getCurrentWeatherByLatLon(lat: userLatitude, lon: userLongitude) { (currentWeather) in
                self.checkCurrentWeatherDate(currentWeather)
            }
        }
        removeSearchHistory()
    }
    
    func showMessageDialog(title :String, msg :String, butMsg :String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: butMsg, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeSearchHistory() {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.endEditing(true)
        historyView.removeFromSuperview()
    }
    
    func refreshHistoryList(location: String) {
        let userDefault = UserDefaults()
        if (historyArray.contains(location)) {
            var tempList : NSArray = []
            for obj in historyArray {
                if ((obj as! String) != location) {
                    tempList = tempList.adding(obj as! String) as NSArray
                }
            }
            historyArray = tempList
        }
        historyArray = historyArray.adding(location) as NSArray
        userDefault.set(historyArray, forKey: "historyName")
    }
    
    func updateWeatherDataToUI (data: CurrentWeatherData) {
        locationLabel.text = (data.location.isEmpty) ? "?" : data.location

        let format = DateFormatter()
        let date = NSDate(timeIntervalSince1970: TimeInterval(data.dt))
        format.timeZone = TimeZone(secondsFromGMT: data.timeZone)
        format.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateLabel.text = format.string(from: date as Date)
        
        weatherLabel.text = data.weather
        weatherIcon.sd_setImage(with: URL(string: "https://openweathermap.org/img/wn/\(data.icon)@2x.png"))
        
        currentTemperature.text = String(format:"%.1f℃",data.currentTemp)
        highestTemperature.text = String(format:"%.1f℃",data.maxTemp)
        lowestTemperature.text = String(format:"%.1f℃",data.minTemp)
    }
    
    func checkCurrentWeatherDate(_ data :CurrentWeatherData) {
        if (data.cod == "200") {
            let userDefault = UserDefaults()
            userDefault.set(data.location, forKey: "cityName")
            self.updateWeatherDataToUI(data: data)
        } else if (data.cod == "404") {
            showMessageDialog(title: "Error", msg: "Please ensure \"City Name\" / \"Zip Code\" is correct!", butMsg: "OK")
        } else if (data.cod == "400") {
            showMessageDialog(title: "Error", msg: "Please ensure \"Zip Code\" is valid !", butMsg: "OK")
        } else if (data.cod == "0") {
            showMessageDialog(title: "Error", msg: "Cannot connect to the open weather server", butMsg: "OK")
        }
    }
    
    // Tableview initiation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = historyArray[historyArray.count - 1 - indexPath.row] as! String
        searchBar.text = searchText
        refreshHistoryList(location: searchText)
        if (Formatter.checkNumberic(searchText)) {
            OpenWeatherManager.getCurentWeatherByZipCode(searchText) {(currentWeather) in
                self.checkCurrentWeatherDate(currentWeather)
            }
        } else {
            OpenWeatherManager.getCurrentWeatherByCity(searchText) {(currentWeather) in
                self.checkCurrentWeatherDate(currentWeather)
            }
        }
        removeSearchHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(historyArray[historyArray.count - 1 - indexPath.row])"
        return cell
    }
    
    
    
    // Degelate Function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        historyView.reloadData()
        self.view.addSubview(historyView)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchHistory()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text as String? else {
            print("searchBar cannot convert to string")
            return
        }
        if (!searchText.isEmpty) {
            //Store history
            refreshHistoryList(location: searchText)
            if (Formatter.checkNumberic(searchText)) {
                OpenWeatherManager.getCurentWeatherByZipCode(searchText) {(currentWeather) in
                    self.checkCurrentWeatherDate(currentWeather)
                }
            } else {
                OpenWeatherManager.getCurrentWeatherByCity(searchText) {(currentWeather) in
                    self.checkCurrentWeatherDate(currentWeather)
                }
            }
        }
        removeSearchHistory()
    }
}
