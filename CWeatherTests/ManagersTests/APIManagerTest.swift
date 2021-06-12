//
//  APIManagerTest.swift
//  CWeatherTests
//
//  Created by vlsuv on 12.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import CWeather

class APIManagerTest: XCTestCase {
    
    var sut: WeatherAPIManager?
    var sessionConfiguration: URLSessionConfiguration?

    override func setUpWithError() throws {
        sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration!.protocolClasses = [MockURLProtocol.self]
        
        sut = WeatherAPIManager(sessionConfiguration: sessionConfiguration!, apiKey: "Bar")
    }

    override func tearDownWithError() throws {
        sessionConfiguration = nil
        sut = nil
    }
    
    func testInitWeatherAPIManager() {
        XCTAssertNotNil(sut)
    }
    
    func testSuccesFetchingCurrentWeather() throws {
        let currentWeatherArray: [String: Any] = [
            "name": "Bar",
            "main": [
                "temp": 1.0, "feels_like": 1.0 ], "weather": [ [ "main": "Rain", "description": "Baz"
                    ]
            ]
        ]
        let currentWeatherData = try JSONSerialization.data(withJSONObject: currentWeatherArray)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), currentWeatherData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut?.JSONWeatherWith(locationName: "Bar") { result in
            switch result {
            case .Succes(let weather):
                XCTAssertEqual(weather.locationName, "Bar")
                XCTAssertEqual(weather.description, "Baz")
                expectation.fulfill()
            case .Failure(_):
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testUnsuccessfulFetchingCurrentWeather() throws {
        let currentWeatherArray: [String: Any] = [String: Any]()
        let emptyArray = try JSONSerialization.data(withJSONObject: currentWeatherArray)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), emptyArray)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut?.JSONWeatherWith(locationName: "Bar") { result in
            switch result {
            case .Succes(_):
                XCTFail()
            case .Failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
