//
//  UIViewController Extensions.swift
//  CWeather
//
//  Created by vlsuv on 05.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String?, message: String?) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        
        self.present(alerController, animated: true, completion: nil)
    }
}
