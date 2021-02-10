//
//  WeatherImageManager.swift
//  CWeather
//
//  Created by vlsuv on 10.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum WeatherImageManager: String {
    case Thunderstorm = "Thunderstorm"
    case Rain = "Rain"
    case Snow = "Snow"
    case Atmosphere = "Atmosphere"
    case Sun = "Sun"
    case Clouds = "Clouds"
    
    init(rawValue: String) {
        switch rawValue {
        case "Thunderstorm": self = .Thunderstorm
        case "Drizzle": self = .Thunderstorm
        case "Rain": self = .Rain
        case "Snow": self = .Snow
        case "Atmosphere": self = .Atmosphere
        case "Clear": self = .Sun
        case "Clouds": self = .Clouds
        default: self = .Sun
        }
    }
    
    var icon: UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}
