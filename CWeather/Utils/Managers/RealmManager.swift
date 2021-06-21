//
//  RealmManager.swift
//  CWeather
//
//  Created by vlsuv on 21.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    // MARK: - Properties
    private let realmService: RealmServiceProtocol
    
    // MARK: - Init
    init() {
        realmService = RealmService()
    }
    
    func addLocation(name: String, completionHandler: (Bool) -> ()) {
        let location = Location(name: name)
        realmService.add(location, completionHandler: completionHandler)
    }
    
    func deleteLocation(_ location: Location, completionHandler: (Bool) -> ()) {
        realmService.delete(location, completionHandler: completionHandler)
    }
    
    func getLocations(completionHandler: (Results<Location>) -> ()) {
        realmService.fetch(Location.self, completionHandler: completionHandler)
    }
    
}
