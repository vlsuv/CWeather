//
//  UILabel Extensions.swift
//  CWeather
//
//  Created by vlsuv on 22.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UILabel {
    func add(image: UIImage, with text: String) {
        
        self.tintColor = Colors.white
        image.withTintColor(self.textColor, renderingMode: .alwaysTemplate)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -8.5, width: image.size.width, height: image.size.height)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        
        let textAfterIcon = NSAttributedString(string: text)
        completeText.append(textAfterIcon)
        
        self.attributedText = completeText
    }
}
