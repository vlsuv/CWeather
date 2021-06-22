//
//  CurrentWeatherView.swift
//  CWeather
//
//  Created by vlsuv on 22.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class CurrentWeatherView: UIView {
    
    // MARK: - Search Location Elements
    lazy var searchLocationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchLocationTextField, searchLocationButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addBackground(color: Colors.white)
        return stackView
    }()
    
    var searchLocationTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.placeholder = "Enter the city name"
        textField.returnKeyType = .search
        return textField
    }()
    
    var searchLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.search, for: .normal)
        button.tintColor = Colors.black
        return button
    }()
    
    // MARK: - Top Elements
    lazy var topStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [humidityImageLabelView, pressureImageLabelView, windSpeedImageLabelView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    var humidityImageLabelView: ImageLabelView = {
        let imageLabelView = ImageLabelView()
        imageLabelView.image = Images.humidity
        return imageLabelView
    }()
    
    var pressureImageLabelView: ImageLabelView = {
        let imageLabelView = ImageLabelView()
        let pressureImage = Images.pressure
        pressureImage.withRenderingMode(.alwaysTemplate)
        imageLabelView.image = pressureImage
        return imageLabelView
    }()
    
    var windSpeedImageLabelView: ImageLabelView = {
        let imageLabelView = ImageLabelView()
        imageLabelView.image = Images.wind
        return imageLabelView
    }()
    
    // MARK: - Temp Elements
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempLabel, detailTempStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var detailTempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTempLabel, minTempLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .systemFont(ofSize: 76, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var minTempLabel: ImageLabelView = {
        let imageLabelView = ImageLabelView()
        imageLabelView.image = Images.arrowDown
        return imageLabelView
    }()
    
    lazy var maxTempLabel: ImageLabelView = {
        let imageLabelView = ImageLabelView()
        imageLabelView.image = Images.arrowUp
        return imageLabelView
    }()
    
    
    // MARK: Location Elements
    lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationNameLabel, localDateLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    var locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .systemFont(ofSize: 46, weight: .medium)
        return label
    }()
    
    var localDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = Colors.white
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var backgroundGradiendLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [AssetsColor.mediumBlue.cgColor, AssetsColor.darkBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundGradiendLayer.frame = self.bounds
        self.layer.insertSublayer(backgroundGradiendLayer, at: 0)
        
        addSubview(activityIndicator)
        activityIndicator.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
        
        setupSearchLocationElements()
        setupTopElements()
        setupTempElements()
        setupCityElements()
        setupWeatherImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    private func setupSearchLocationElements() {
        addSubview(searchLocationStackView)
        
        searchLocationStackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                                       left: leftAnchor,
                                       right: rightAnchor,
                                       topPadding: 30,
                                       leftPadding: 30,
                                       rightPadding: 30,
                                       height: 34)
        
        searchLocationButton.anchor(right: searchLocationStackView.rightAnchor, height: 30, width: 30)
    }
    
    private func setupTopElements() {
        addSubview(topStackView)
        
        topStackView.anchor(top: searchLocationStackView.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            topPadding: 30,
                            leftPadding: 30,
                            rightPadding: 30,
                            height: 34)
    }
    
    private func setupTempElements() {
        addSubview(tempStackView)
        tempStackView.anchor(top: topStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 30, leftPadding: 30, rightPadding: 30)
    }
    
    private func setupCityElements() {
        addSubview(locationStackView)
        
        locationStackView.anchor(top: tempStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 30, leftPadding: 30, rightPadding: 30)
    }
    
    private func setupWeatherImageView() {
        addSubview(weatherImageView)
        weatherImageView.anchor(top: locationStackView.bottomAnchor, topPadding: 30, height: 110, width: 110, centerX: centerXAnchor)
    }
}

extension CurrentWeatherView {
    func updateUIWith(_ currentWeather: CurrentWeather) {
        humidityImageLabelView.text = "\(currentWeather.humidity)%"
        pressureImageLabelView.text = "\(currentWeather.pressure)"
        windSpeedImageLabelView.text = "\(currentWeather.windSpeed)m/s"
        
        tempLabel.text = currentWeather.tempString
        maxTempLabel.text = "\(currentWeather.maxTemp)"
        minTempLabel.text = "\(currentWeather.minTemp)"
        
        locationNameLabel.text = currentWeather.locationName
        localDateLabel.text = currentWeather.localDateString
        descriptionLabel.text = currentWeather.description
        weatherImageView.image = currentWeather.icon.getImage()
        
        switch currentWeather.timeStatus {
        case .Light:
            backgroundGradiendLayer.colors = [AssetsColor.mediumBlue.cgColor, AssetsColor.darkBlue.cgColor]
        case .Dark:
            backgroundGradiendLayer.colors = [AssetsColor.mediumGray.cgColor, AssetsColor.darkGray.cgColor]
        }
    }
    
    private func hideElements(isOn: Bool) {
        searchLocationStackView.isHidden = isOn
        topStackView.isHidden = isOn
        tempStackView.isHidden = isOn
        locationStackView.isHidden = isOn
        weatherImageView.isHidden = isOn
    }
    
    func toogleActivityIndicatorStatus(isOn: Bool) {
        activityIndicator.isHidden = !isOn
        hideElements(isOn: isOn)
        
        switch isOn {
        case true:
            activityIndicator.startAnimating()
        case false:
            activityIndicator.stopAnimating()
        }
    }
}
