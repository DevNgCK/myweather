//
//  CurrentWeatherDataTests.swift
//  WeatherCheckerTests
//
//  Created by Gavin Ng on 17/7/2021.
//

import XCTest
@testable import WeatherChecker

class CurrentWeatherDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentWeatherData() throws {
        let testData = CurrentWeatherData(cod: "200",location: "Testing", dt: 500, timeZone: 400,
                                          weather: "Rain", icon: "01d",
                                          maxTemp: 300, minTemp: 200, currentTemp: 100, lat: 1.1, lon: 1.2)
        XCTAssertEqual(testData.location, "Testing")
        XCTAssertEqual(testData.cod, "200")
        XCTAssertEqual(testData.dt, 500)
        XCTAssertEqual(testData.timeZone, 400)
        XCTAssertEqual(testData.weather, "Rain")
        XCTAssertEqual(testData.icon, "01d")
        XCTAssertEqual(testData.maxTemp, 300)
        XCTAssertEqual(testData.minTemp, 200)
        XCTAssertEqual(testData.currentTemp, 100)
        XCTAssertEqual(testData.lat, 1.1)
        XCTAssertEqual(testData.lon, 1.2)
    }

}
