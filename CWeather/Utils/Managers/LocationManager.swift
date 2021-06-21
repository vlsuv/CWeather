//
//  LocationManager.swift
//  CWeather
//
//  Created by vlsuv on 06.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationResult {
    case Succes(String)
    case Failure(Error)
}

protocol LocationManagerProtocol {
    var didUpdateLocation: ((LocationResult) -> ())? { get set }
    func fetchLocation()
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    // MARK: - Properties
    private let manager: CLLocationManager
    
    var didUpdateLocation: ((LocationResult) -> ())?
    
    // MARK: - Init
    override init() {
        self.manager = CLLocationManager()
        super.init()
    }
}

// MARK: - Location Manage
extension LocationManager {
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.didUpdateLocation?(.Failure(ErrorManager.LocationServicesError))
            return
        }
        setupLocationManager()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            self.didUpdateLocation?(.Failure(ErrorManager.AuthorizationStatusError))
        case .denied:
            self.didUpdateLocation?(.Failure(ErrorManager.AuthorizationStatusError))
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            self.didUpdateLocation?(.Failure(ErrorManager.AuthorizationStatusError))
        }
    }
    
    func getLocationName(with location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemark, error in
            if let error = error {
                self?.didUpdateLocation?(.Failure(error))
                return
            }
            
            guard let placemark = placemark?.first, let locationName = placemark.locality else {
                self?.didUpdateLocation?(.Failure(ErrorManager.MissingLocationCordinateError))
                return
            }
            
            self?.didUpdateLocation?(.Succes(locationName))
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        manager.stopUpdatingLocation()
        
        getLocationName(with: location)
    }
}
