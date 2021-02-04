//
//  ViewController.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class CurrentWeatherController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData()
    }
    
    // MARK: - Handlers
    private func fetchWeatherData() {
//        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=d4778fc83753819972da2707d8ade3d1&mode=json&units=metric") else { return }
//
//        let sessionConfiguration = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfiguration)
//
//        let dataTask = session.dataTask(with: url) { data, responce, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//
//                guard let data = data else { return }
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                    let currentWeather = CurrentWeather(json: json!)
//                    self.updateUIWith(currentWeather!)
//                }catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        dataTask.resume()
    }
    
    private func updateUIWith(_ currentWeather: CurrentWeather) {
        tempLabel.text = currentWeather.tempString
        feelLikeLabel.text = currentWeather.feelsLikeString
        descriptionLabel.text = currentWeather.description
        weatherImageView.image = currentWeather.icon
        locationNameLabel.text = currentWeather.locationName
    }
}

