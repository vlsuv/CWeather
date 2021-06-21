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
}

extension CurrentWeather {
    init?(json: [String: Any]) {
        guard let mainDictionary = json["main"] as? [String: AnyObject], let weatherDictionaries = json["weather"] as? [[String: AnyObject]], let firstWeatherDictionary = weatherDictionaries.first else { return nil }
        
        let icon = WeatherImageManager(rawValue: firstWeatherDictionary["main"] as? String ?? "").icon
        
        self.locationName = json["name"] as? String ?? ""
        self.description = firstWeatherDictionary["description"] as? String ?? ""
        self.icon = Image(withImage: icon)
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

struct Image: Codable, Equatable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        
        let image = UIImage(data: imageData)
        return image
    }
}
