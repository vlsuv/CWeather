//
//  CurrentWeatherModelTest.swift
//  CWeatherTests
//
//  Created by vlsuv on 12.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import CWeather

class CurrentWeatherModelTest: XCTestCase {
    
    func testInitCurrentWeatherModel() {
        let image = Image(withImage: WeatherImageManager.Rain.icon)
        let currentWeatherModel = CurrentWeather(locationName: "Bar", description: "Baz", icon: image, temp: 1.0, feelsLike: 1.0)
        
        XCTAssertNotNil(currentWeatherModel)
        XCTAssertEqual(currentWeatherModel.locationName, "Bar")
        XCTAssertEqual(currentWeatherModel.description, "Baz")
        XCTAssertEqual(currentWeatherModel.temp, 1.0)
        XCTAssertEqual(currentWeatherModel.feelsLike, 1.0)
        XCTAssertEqual(currentWeatherModel.icon, image)
    }
    
    func testJsonInitCurrentWeatherModel() {
        let currentWeatherArray: [String: Any] = [
            "name": "Bar", "main": ["temp": 1.0, "feels_like": 1.0 ], "weather": [ [ "main": "Rain", "description": "Baz"]],
        ]
        
        let currentWeatherModel = CurrentWeather(json: currentWeatherArray)
        
        XCTAssertNotNil(currentWeatherModel)
        XCTAssertEqual(currentWeatherModel?.locationName, "Bar")
        XCTAssertEqual(currentWeatherModel?.description, "Baz")
        XCTAssertEqual(currentWeatherModel?.temp, 1.0)
        XCTAssertEqual(currentWeatherModel?.feelsLike, 1.0)
    }
    
    func testInitDefaultAndJsonAndEqual() {
        let icon = Image(withImage: WeatherImageManager.Rain.icon)
        let defaultCurrentWeatherModel = CurrentWeather(locationName: "Bar",
                                                        description: "Baz",
                                                        icon: icon,
                                                        temp: 1.0,
                                                        feelsLike: 1.0)
        
        
        let currentWeatherArray: [String: Any] = [
            "name": "Bar", "main": ["temp": 1.0, "feels_like": 1.0 ], "weather": [ [ "main": "Rain", "description": "Baz"]],
        ]
        let jsonCurrentWeatherModel = CurrentWeather(json: currentWeatherArray)
        
        XCTAssertEqual(defaultCurrentWeatherModel, jsonCurrentWeatherModel)
    }
}
