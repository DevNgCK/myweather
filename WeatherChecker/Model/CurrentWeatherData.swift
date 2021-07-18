//
//  CurrentWeatherData.swift
//  WeatherChecker
//
//  Created by Gavin Ng on 17/7/2021.
//

import Foundation

struct CurrentWeatherData {
    var cod = "0"
    
    var location = ""
    
    var dt = 0
    var timeZone = 0
    
    var weather = ""
    var icon = ""
    
    var maxTemp = 0.0
    var minTemp = 0.0
    var currentTemp = 0.0
    
    var lat = 0.0
    var lon = 0.0
    
    var description: String {
            return
                "cod: \(cod)\n" +
                "location: \(location)\n" +
                "dt: \(dt)\n" +
                "weather: \(weather)\n" +
                "icon: \(icon)\n" +
                "timeZone: \(timeZone)\n" +
                "maxTemp: \(maxTemp)\n" +
                "minTemp: \(minTemp)\n" +
                "currentTemp: \(currentTemp)\n" +
                "lat: \(lat)\n" +
                "lon: \(lon)\n"
    }
    
    
}
