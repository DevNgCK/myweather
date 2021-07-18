//
//  OpenWeatherManagerTests.swift
//  WeatherCheckerTests
//
//  Created by Gavin Ng on 17/7/2021.
//

import XCTest
@testable import WeatherChecker

class OpenWeatherManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCurrentWeatherByCity() throws {
        let exp = expectation(description: "Unit Test Asynchronous Function")
        OpenWeatherManager.getCurrentWeatherByCity("HongKong") {
            (currentWeather) in
            XCTAssertEqual(currentWeather.cod, "200")
        }
        OpenWeatherManager.getCurrentWeatherByCity("HongKong22") {
            (currentWeather) in
            XCTAssertEqual(currentWeather.cod, "404")
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }

}
