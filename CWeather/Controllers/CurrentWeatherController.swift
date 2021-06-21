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
    
    private var locationManager: LocationManagerProtocol?
    private var realmManager: RealmManager?
    
    @IBOutlet weak var searchLocationView: UIView!
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var searchLocationButton: UIButton!
    
    private var currentLocationName: String?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        setupSearchLocationView()
        setupBacgroundGradientLayer()
        setupTheme()
        
        setupLocationManager()
        fetchLocationName()
        
        realmManager = RealmManager()
    }
    
    // MARK: - Actions
    @IBAction func handleRefresh(_ sender: UIBarButtonItem) {
        guard let currentLocationName = currentLocationName else {
            fetchLocationName()
            toogleActivityIndicatorStatus(isOn: true)
            return
        }
        toogleActivityIndicatorStatus(isOn: true)
        fetchWeatherData(locationName: currentLocationName)
    }
    
    @IBAction func didTapSearchLocationButton(_ sender: Any) {
        guard let location = searchLocationTextField.text, !location.isEmpty else { return }
        
        searchLocationTextField.text = ""
        searchLocationTextField.resignFirstResponder()
        fetchWeatherData(locationName: location)
    }
    
    @IBAction func didTapAddLocationButton(_ sender: Any) {
        guard let currentLocationName = currentLocationName else { return }
        
        realmManager?.addLocation(name: currentLocationName, completionHandler: { [weak self] succes in
            if succes {
                self?.showAlertController(title: "Add Location", message: "")
            }
        })
    }
    
    @IBAction func didTapLocationListButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let locationListController = storyboard.instantiateViewController(identifier: "locationListController") as? LocationListController else { return }
        
        navigationController?.pushViewController(locationListController, animated: true)
        locationListController.didSelectLocation = didSelectLocation(_:)
    }
    
    func didSelectLocation(_ name: String) {
        navigationController?.popViewController(animated: true)
        fetchWeatherData(locationName: name)
    }
    
    // MARK: - Setups
    private func setupLocationManager() {
        locationManager = LocationManager()
        
        locationManager?.didUpdateLocation = { [weak self] result in
            switch result {
            case .Succes(let locationName):
                self?.fetchWeatherData(locationName: locationName)
            case .Failure(let error):
                self?.showAlertController(title: error.localizedDescription, message: "")
            }
        }
    }
    
    // MARK: - Fetches
    private func fetchLocationName() {
        toogleActivityIndicatorStatus(isOn: true)
        self.locationManager?.fetchLocation()
    }
    
    private func fetchWeatherData(locationName: String) {
        weatherAPIManager.JSONWeatherWith(locationName: locationName) { [weak self] APIResult in
            switch APIResult {
            case .Succes(let currentWeather):
                DispatchQueue.main.async {
                    self?.toogleActivityIndicatorStatus(isOn: false)
                    self?.updateUIWith(currentWeather)
                    self?.currentLocationName = currentWeather.locationName
                }
            case .Failure(let error as NSError):
                self?.showAlertController(title: error.localizedDescription, message: nil)
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
    
    private func setupSearchLocationView() {
        searchLocationTextField.delegate = self
        
        searchLocationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        searchLocationTextField.leftViewMode = .always
        searchLocationTextField.placeholder = "Enter the city name"
        searchLocationTextField.returnKeyType = .search
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
        weatherImageView.image = currentWeather.icon.getImage()
        locationNameLabel.text = currentWeather.locationName
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

// MARK: - UITextFieldDelegate
extension CurrentWeatherController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchLocationTextField {
            guard let location = searchLocationTextField.text, !location.isEmpty else { return false }
            
            searchLocationTextField.text = ""
            searchLocationTextField.resignFirstResponder()
            fetchWeatherData(locationName: location)
            return true
        }
        return false
    }
}
