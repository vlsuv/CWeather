//
//  WeatherAPIManager.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

protocol FinalForecastURL {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum ForecastType: FinalForecastURL {
    case Current(apiKey: String, locationName: String)
    
    var baseURL: URL {
        return URL(string: "http://api.openweathermap.org")!
    }
    var path: String {
        switch self {
        case .Current(apiKey: let apiKey, locationName: let locationName):
            return "/data/2.5/weather?q=\(locationName)&appid=\(apiKey)&mode=json&units=metric"
        }
    }
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class WeatherAPIManager: APIManager {
    
    // MARK: - Properties
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    let apiKey: String
    
    // MARK: - Init
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: .default, apiKey: apiKey)
    }
}

extension WeatherAPIManager {
    func JSONWeatherWith(locationName: String, completionHandler: @escaping (APIResult<CurrentWeather>) -> ()) {
        let safeLocationName = locationName.replacingOccurrences(of: " ", with: "")
        let request = ForecastType.Current(apiKey: self.apiKey, locationName: safeLocationName).request
        
        fetch(request: request, parse: { json -> CurrentWeather? in
            return CurrentWeather(json: json)
        }) { APIResult in
            DispatchQueue.main.async {
                completionHandler(APIResult)
            }
        }
    }
}
