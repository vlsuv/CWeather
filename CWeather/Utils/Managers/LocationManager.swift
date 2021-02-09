//
//  LocationManager.swift
//  CWeather
//
//  Created by vlsuv on 06.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationResult<T> {
    case Succes(String)
    case Failure(Error)
}

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func fetchLocation(completionHandler: (CLLocation?, Error?) -> ()) {
        guard CLLocationManager.locationServicesEnabled() else {
            completionHandler(nil, ErrorManager.LocationServicesError)
            return
        }
        setupLocationManager()
        
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            completionHandler(nil, ErrorManager.AuthorizationStatusError)
            return
        }
        
        let currentLocation = manager.location
        completionHandler(currentLocation, nil)
    }
    
    func fetchLocationName(completionHandler: @escaping (LocationResult<String>) -> ()) {
        fetchLocation { location, error in
            DispatchQueue.global().async {
                if let error = error {
                    completionHandler(.Failure(error))
                    return
                }
                
                guard let location = location else {
                    completionHandler(.Failure(ErrorManager.MissingLocationCordinateError))
                    return
                }
                
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemark, error in
                    if let error = error {
                        completionHandler(.Failure(error))
                        return
                    }
                    
                    guard let placemark = placemark?.first, let locationName = placemark.locality else {
                        return
                    }
                    
                    completionHandler(.Succes(locationName))
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
}
