//
//  Image.swift
//  CWeather
//
//  Created by vlsuv on 22.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum Images {
    static let arrowUp = UIImage(systemName: "arrow.up") ?? UIImage()
    static let arrowDown = UIImage(systemName: "arrow.down") ?? UIImage()
    static let back = UIImage(systemName: "chevron.left") ?? UIImage()
    static let wind = UIImage(systemName: "wind") ?? UIImage()
    static let humidity = UIImage(named: "humidity") ?? UIImage()
    static let pressure = UIImage(named: "gauge") ?? UIImage()
    
    static let refresh = UIImage(systemName: "goforward")
    static let myLocation = UIImage(systemName: "location.circle")
    static let plus = UIImage(systemName: "plus")
    static let list = UIImage(systemName: "text.justify")
    static let search = UIImage(systemName: "magnifyingglass")
}
