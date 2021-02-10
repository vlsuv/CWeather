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
    private var bacgroundGradientLayer: CAGradientLayer!
    
    private let weatherAPIManager = WeatherAPIManager(apiKey: "d4778fc83753819972da2707d8ade3d1")
    private let locationManager = LocationManager()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        setupBacgroundGradientLayer()
        setupTheme()
        
        fetchLocationName()
    }
    
    // MARK: - Actions
    @IBAction func handleRefresh(_ sender: UIBarButtonItem) {
        fetchWeatherData(locationName: "Moscow")
    }
    
    // MARK: - Fetches
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
    private func configureNavigationController() {
        navigationController?.toTransparent()
    }
    
    private func setupTheme() {
        tempLabel.textColor = Colors.white
        tempLabel.font = .systemFont(ofSize: 76, weight: .medium)
        
        feelLikeLabel.textColor = Colors.white
        feelLikeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        descriptionLabel.textColor = Colors.white
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        locationNameLabel.textColor = Colors.white
        locationNameLabel.font = .systemFont(ofSize: 46, weight: .medium)
        
        activityIndicator.color = Colors.white
    }
    
    private func setupBacgroundGradientLayer() {
        bacgroundGradientLayer = CAGradientLayer()
        bacgroundGradientLayer.colors = [AssetsColor.darkBlue.cgColor, AssetsColor.mediumBlue.cgColor]
        bacgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        bacgroundGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        bacgroundGradientLayer.frame = view.bounds
        view.layer.insertSublayer(bacgroundGradientLayer, at: 0)
    }
    
    private func updateUIWith(_ currentWeather: CurrentWeather) {
        tempLabel.text = currentWeather.tempString
        feelLikeLabel.text = currentWeather.feelsLikeString
        descriptionLabel.text = currentWeather.description
        weatherImageView.image = currentWeather.icon
        locationNameLabel.text = currentWeather.locationName
        weatherImageView.image = currentWeather.icon
    }
    
    private func hideElements(isOn: Bool) {
        tempLabel.isHidden = isOn
        feelLikeLabel.isHidden = isOn
        descriptionLabel.isHidden = isOn
        weatherImageView.isHidden = isOn
        locationNameLabel.isHidden = isOn
    }
    
    private func toogleActivityIndicatorStatus(isOn: Bool) {
        activityIndicator.isHidden = !isOn
        hideElements(isOn: isOn)
        
        switch isOn {
        case true:
            
            activityIndicator.startAnimating()
        case false:
            activityIndicator.stopAnimating()
        }
    }
}
