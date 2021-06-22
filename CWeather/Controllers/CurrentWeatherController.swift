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
    private let weatherAPIManager = WeatherAPIManager(apiKey: "d4778fc83753819972da2707d8ade3d1")
    
    private var locationManager: LocationManagerProtocol?
    private var realmManager: RealmManager?
    
    private var currentLocationName: String?
    
    private var contentView: CurrentWeatherView?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        configureNavigationController()
        setupTargets()
        
        setupLocationManager()
        
        fetchLocationName()
        
        realmManager = RealmManager()
    }
    
    // MARK: - Targets
    @objc private func didTapRefreshLocationButton() {
        guard let currentLocationName = currentLocationName else {
            fetchLocationName()
            contentView?.toogleActivityIndicatorStatus(isOn: true)
            return
        }
        contentView?.toogleActivityIndicatorStatus(isOn: true)
        fetchWeatherData(locationName: currentLocationName)
    }
    
    @objc private func didTapCurrentLocationButton() {
        fetchLocationName()
    }
    
    @objc private func didTapAddLocationButton() {
        guard let currentLocationName = currentLocationName else { return }
        
        realmManager?.addLocation(name: currentLocationName, completionHandler: { [weak self] succes in
            if succes {
                self?.showAlertController(title: "Add Location", message: "")
            }
        })
    }
    
    @objc private func didTapLocationListButton() {
        let locationListController = LocationListController()
        locationListController.didSelectLocation = didSelectLocation(_:)
        navigationController?.pushViewController(locationListController, animated: true)
    }
    
    func didSelectLocation(_ name: String) {
        navigationController?.popViewController(animated: true)
        fetchWeatherData(locationName: name)
    }
    
    @objc private func didTapSearchLocationButton() {
        guard let location = contentView?.searchLocationTextField.text, !location.isEmpty else { return }
        
        contentView?.searchLocationTextField.text = ""
        contentView?.searchLocationTextField.resignFirstResponder()
        fetchWeatherData(locationName: location)
    }
    
    // MARK: - Setups
    private func configureNavigationController() {
        let refreshButton = UIBarButtonItem(image: Images.refresh, style: .plain, target: self, action: #selector(didTapRefreshLocationButton))
        let myLocationButton = UIBarButtonItem(image: Images.myLocation, style: .plain, target: self, action: #selector(didTapCurrentLocationButton))
        
        let addLocationButton = UIBarButtonItem(image: Images.plus, style: .plain, target: self, action: #selector(didTapAddLocationButton))
        let locationListButton = UIBarButtonItem(image: Images.list, style: .plain, target: self, action: #selector(didTapLocationListButton))
        
        navigationItem.leftBarButtonItems = [refreshButton, myLocationButton]
        navigationItem.rightBarButtonItems = [locationListButton, addLocationButton]
        
        navigationController?.toTransparent()
        navigationController?.navigationBar.tintColor = Colors.white
    }
    
    private func setupContentView() {
        contentView = CurrentWeatherView(frame: view.bounds)
        view.addSubview(contentView!)
        contentView?.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        contentView?.searchLocationTextField.delegate = self
    }
    
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
    
    private func setupTargets() {
        contentView?.searchLocationButton.addTarget(self, action: #selector(didTapSearchLocationButton), for: .touchUpInside)
    }
    
    
    // MARK: - Fetches
    private func fetchLocationName() {
        contentView?.toogleActivityIndicatorStatus(isOn: true)
        self.locationManager?.fetchLocation()
    }
    
    private func fetchWeatherData(locationName: String) {
        weatherAPIManager.JSONWeatherWith(locationName: locationName) { [weak self] APIResult in
            switch APIResult {
            case .Succes(let currentWeather):
                DispatchQueue.main.async {
                    self?.contentView?.toogleActivityIndicatorStatus(isOn: false)
                    self?.contentView?.updateUIWith(currentWeather)
                    self?.currentLocationName = currentWeather.locationName
                }
            case .Failure(let error as NSError):
                self?.showAlertController(title: error.localizedDescription, message: nil)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension CurrentWeatherController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentView?.searchLocationTextField {
            guard let location = contentView?.searchLocationTextField.text, !location.isEmpty else { return false }
            
            contentView?.searchLocationTextField.text = ""
            contentView?.searchLocationTextField.resignFirstResponder()
            fetchWeatherData(locationName: location)
            return true
        }
        return false
    }
}
