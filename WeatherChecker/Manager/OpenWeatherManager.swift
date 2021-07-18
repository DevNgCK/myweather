//
//  OpenWeatherManager.swift
//  WeatherChecker
//
//  Created by Gavin Ng on 17/7/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class OpenWeatherManager {
    static var apiDomain = "https://api.openweathermap.org/data/2.5/"
    static var apiKey = "95d190a434083879a6398aafd54d9e73"
    
    static func getCurrentWeatherByCity(_ city :String, completion: @escaping (CurrentWeatherData) -> Void) {
        let request = AF.request(apiDomain + "weather?q=\(city.replacingOccurrences(of: " ", with: ""))&appid=\(apiKey)")
        request.responseJSON { (data) in
            do {
                if data.data != nil {
                    let json = try JSON(data: data.data!)
                    if (json["cod"].int == 200) {
                        completion(CurrentWeatherData(cod: "200", location: json["name"].string!,
                                        dt: json["dt"].int!, timeZone: json["timezone"].int!,
                                        weather: json["weather"][0]["main"].string!, icon: json["weather"][0]["icon"].string!,
                                        maxTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        minTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        currentTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        lat: json["coord"]["lat"].double!, lon: json["coord"]["lon"].double!))
                    } else if (json["cod"].string == "404") {
                        completion(CurrentWeatherData(cod: "404"))
                    }
                } else {
                    completion(CurrentWeatherData(cod: "0"))
                }
            } catch {
                print("SwiftyJSON parse error")
            }
        }
    }
    
    static func getCurentWeatherByZipCode(_ code :String, completion: @escaping (CurrentWeatherData) -> Void) {
        let request = AF.request(apiDomain + "weather?zip=\(code.replacingOccurrences(of: " ", with: ""))&appid=\(apiKey)")
        request.responseJSON { (data) in
            do {
                if data.data != nil {
                    let json = try JSON(data: data.data!)
                    if (json["cod"].int == 200) {
                        completion(CurrentWeatherData(cod: "200", location: json["name"].string!,
                                        dt: json["dt"].int!, timeZone: json["timezone"].int!,
                                        weather: json["weather"][0]["main"].string!, icon: json["weather"][0]["icon"].string!,
                                        maxTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        minTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        currentTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        lat: json["coord"]["lat"].double!, lon: json["coord"]["lon"].double!))
                    } else if (json["cod"].string == "404") {
                        completion(CurrentWeatherData(cod: "404"))
                    } else if (json["cod"].string == "400") {
                        completion(CurrentWeatherData(cod: "400"))
                    }
                } else {
                    completion(CurrentWeatherData(cod: "0"))
                }
            } catch {
                print("SwiftyJSON parse error")
            }
        }
    }
    
    static func getCurrentWeatherByLatLon(lat :Double, lon :Double, completion: @escaping (CurrentWeatherData) -> Void) {
        let request = AF.request(apiDomain + "weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)")
        request.responseJSON { (data) in
            do {
                if data.data != nil {
                    let json = try JSON(data: data.data!)
                    if (json["cod"].int == 200) {
                        completion(CurrentWeatherData(cod: "200", location: json["name"].string!,
                                        dt: json["dt"].int!, timeZone: json["timezone"].int!,
                                        weather: json["weather"][0]["main"].string!, icon: json["weather"][0]["icon"].string!,
                                        maxTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        minTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        currentTemp: Formatter.kelvinsToCelsius(json["main"]["temp_min"].double!),
                                        lat: json["coord"]["lat"].double!, lon: json["coord"]["lon"].double!))
                    } else if (json["cod"].string == "404") {
                        completion(CurrentWeatherData(cod: "404"))
                    } else if (json["cod"].string == "400") {
                        completion(CurrentWeatherData(cod: "400"))
                    }
                } else {
                    completion(CurrentWeatherData(cod: "0"))
                }
            } catch {
                print("SwiftyJSON parse error")
            }
        }
    }
    
}
