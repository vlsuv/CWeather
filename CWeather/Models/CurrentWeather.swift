//
//  CurrentWeather.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct CurrentWeather: Equatable, Codable {
    let locationName: String
    let description: String
    var icon: Image
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    let minTemp: Double
    let maxTemp: Double
    let pressure: Int
    let windSpeed: Double
    let localDate: Date
}

extension CurrentWeather {
    init?(json: [String: Any]) {
        guard let mainDictionary = json["main"] as? [String: AnyObject],
            let weatherDictionaries = json["weather"] as? [[String: AnyObject]],
            let firstWeatherDictionary = weatherDictionaries.first,
            let windDictionary = json["wind"] as? [String: AnyObject] else {
                return nil
        }
        
        guard let iconName = firstWeatherDictionary["main"] as? String,
            let locationName = json["name"] as? String,
            let description = firstWeatherDictionary["description"] as? String,
            let temp = mainDictionary["temp"] as? Double,
            let feelsLike = mainDictionary["feels_like"] as? Double,
            let humidity = mainDictionary["humidity"] as? Int,
            let minTemp = mainDictionary["temp_min"] as? Double,
            let maxTemp = mainDictionary["temp_max"] as? Double,
            let pressure = mainDictionary["pressure"] as? Int,
            let windSpeed = windDictionary["speed"] as? Double,
            let timezone = json["timezone"] as? TimeInterval else {
                return nil
        }
        let icon = WeatherImageManager(rawValue: iconName).icon
        
        self.locationName = locationName
        self.description = description
        self.icon = Image(withImage: icon)
        self.temp = temp
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.localDate = Date(timeInterval: timezone, since: Date())
    }
}

extension CurrentWeather {
    var tempString: String {
        return "\(temp)°"
    }

    var localDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return "Local time: \(dateFormatter.string(from: self.localDate))"
    }
    
    var timeStatus: LocationTimeStatus {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let hour = calendar.component(.hour, from: localDate)
        
        switch hour {
        case 6..<20:
            return .Light
        default:
            return .Dark
        }
    }
}

enum LocationTimeStatus {
    case Light
    case Dark
}
