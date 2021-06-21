//
//  Location.swift
//  CWeather
//
//  Created by vlsuv on 21.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import RealmSwift

class Location: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
