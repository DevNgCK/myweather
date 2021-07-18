//
//  Formatter.swift
//  WeatherChecker
//
//  Created by Gavin Ng on 17/7/2021.
//

import Foundation

class Formatter {
    
    static func kelvinsToCelsius(_ temperature: Double) -> Double {
        return (temperature - 273)
    }
    
    static func checkNumberic(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
