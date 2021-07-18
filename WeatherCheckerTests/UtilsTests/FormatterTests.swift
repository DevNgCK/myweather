//
//  FormatterTests.swift
//  WeatherCheckerTests
//
//  Created by Gavin Ng on 17/7/2021.
//

import XCTest
@testable import WeatherChecker

class FormatterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFahenheitToCelsius() throws {
        XCTAssertEqual(String(format:"%.1f", Formatter.kelvinsToCelsius(0)), "-273.0")
        XCTAssertEqual(String(format:"%.1f", Formatter.kelvinsToCelsius(300)), "27.0")
        XCTAssertEqual(String(format:"%.1f", Formatter.kelvinsToCelsius(290)), "17.0")

    }
    
    func testCheckNumberic() throws {
        XCTAssertTrue(Formatter.checkNumberic("12342"))
        XCTAssertFalse(Formatter.checkNumberic("abc12342"))
    }
}
