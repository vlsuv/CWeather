//
//  RealmService.swift
//  CWeather
//
//  Created by vlsuv on 21.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import RealmSwift

protocol RealmServiceProtocol {
    func add<T: Object>(_ object: T, completionHandler: (Bool) -> ())
    func delete<T: Object>(_ object: T, completionHandler: (Bool) -> ())
    func fetch<T: Object>(_ object: T.Type, completionHandler: (Results<T>) -> ())
}

class RealmService: RealmServiceProtocol {
    private var realm = try! Realm()
    
    func add<T: Object>(_ object: T, completionHandler: (Bool) -> ()) {
        do {
            try realm.write {
                realm.add(object)
            }
            completionHandler(true)
        } catch {
            print(error)
            completionHandler(false)
        }
    }
    
    func delete<T: Object>(_ object: T, completionHandler: (Bool) -> ()) {
        do {
            try realm.write {
                realm.delete(object)
            }
            completionHandler(true)
        } catch {
            print(error)
            completionHandler(false)
        }
    }
    
    func fetch<T: Object>(_ object: T.Type, completionHandler: (Results<T>) -> ()) {
        let objects = realm.objects(object)
        completionHandler(objects)
    }
}
