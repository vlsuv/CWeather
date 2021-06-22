//
//  ImageModel.swift
//  CWeather
//
//  Created by vlsuv on 22.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct Image: Codable, Equatable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        
        let image = UIImage(data: imageData)
        return image
    }
}
