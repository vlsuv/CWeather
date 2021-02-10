//
//  UINavigationController Extensions.swift
//  CWeather
//
//  Created by vlsuv on 10.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UINavigationController {
    func toTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
    }
}
