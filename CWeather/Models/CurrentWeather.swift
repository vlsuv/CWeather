//
//  CurrentWeather.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct CurrentWeather {
    
    let locationName: String
    let description: String
    let icon: UIImage
    let temp: Double
    let feelsLike: Double
}

extension CurrentWeather {
    init?(json: [String: AnyObject]) {
        guard let mainDictionary = json["main"] as? [String: AnyObject], let weatherDictionaries = json["weather"] as? [[String: AnyObject]], let firstWeatherDictionary = weatherDictionaries.first else { return nil }
        
        self.locationName = json["name"] as? String ?? ""
        self.description = firstWeatherDictionary["description"] as? String ?? ""
        self.icon = UIImage()
        self.temp = mainDictionary["temp"] as? Double ?? 0.0
        self.feelsLike = mainDictionary["feels_like"] as? Double ?? 0.0
    }
}

extension CurrentWeather {
    var tempString: String {
        return "\(temp)°"
    }
    var feelsLikeString: String {
        return "Feels like \(feelsLike)°"
    }
}
