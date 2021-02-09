//
//  ViewController.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let weatherAPIManager = WeatherAPIManager(apiKey: "d4778fc83753819972da2707d8ade3d1")
    let locationManager = LocationManager()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocationName()
    }
    
    // MARK: - Handlers
    private func fetchLocationName() {
        toogleActivityIndicatorStatus(isOn: true)
        
        self.locationManager.fetchLocationName { [weak self] LocationResult in
            switch LocationResult {
            case .Succes(let locationName):
                self?.fetchWeatherData(locationName: locationName)
            case .Failure(let error as NSError):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchWeatherData(locationName: String) {
        weatherAPIManager.JSONWeatherWith(locationName: locationName) { [weak self] APIResult in
            switch APIResult {
            case .Succes(let currentWeather):
                DispatchQueue.main.async {
                    self?.toogleActivityIndicatorStatus(isOn: false)
                    self?.updateUIWith(currentWeather)
                }
            case .Failure(let error as NSError):
                self?.showErrorAlert(title: error.localizedDescription, message: nil)
            }
        }
    }
}

// MARK: - UserInterface
extension CurrentWeatherController {
    private func updateUIWith(_ currentWeather: CurrentWeather) {
        tempLabel.text = currentWeather.tempString
        feelLikeLabel.text = currentWeather.feelsLikeString
        descriptionLabel.text = currentWeather.description
        weatherImageView.image = currentWeather.icon
        locationNameLabel.text = currentWeather.locationName
    }
    
    private func toogleActivityIndicatorStatus(isOn: Bool) {
        activityIndicator.isHidden = !isOn
        
        switch isOn {
        case true:
            activityIndicator.startAnimating()
        case false:
            activityIndicator.stopAnimating()
        }
    }
}
