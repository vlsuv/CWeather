//
//  ImageLabelView.swift
//  CWeather
//
//  Created by vlsuv on 22.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ImageLabelView: UIView {
    
    // MARK: - Properties
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Colors.white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var text: String? {
        get {
            label.text
        } set {
            label.text = newValue
        }
    }
    
    var image: UIImage? {
        get {
            imageView.image
        } set {
            imageView.image = newValue
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    private func addSubviews() {
        [imageView, label].forEach { addSubview($0) }
    }
    
    private func setupConstaints() {
        imageView.anchor(left: leftAnchor,
                         height: 20,
                         width: 20,
                         centerY: centerYAnchor)
        
        label.anchor(top: topAnchor,
                     left: imageView.rightAnchor,
                     right: rightAnchor,
                     bottom: bottomAnchor,
                     leftPadding: 8)
    }
}
