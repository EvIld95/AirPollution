//
//  DevicesCollectionViewCell.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class DevicesCollectionViewCell: UICollectionViewCell {
    let deviceImageView: UIImageView = {
        let div = UIImageView(image: #imageLiteral(resourceName: "device").withRenderingMode(.alwaysOriginal))
        div.contentMode = .scaleAspectFit
        div.clipsToBounds = true
        return div
    }()
    
    let localizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Poznan"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = "1012hPa"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "88%"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "12C"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let pm10Label: UILabel = {
        let label = UILabel()
        label.text = "Pm10"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let pm25Label: UILabel = {
        let label = UILabel()
        label.text = "Pm25"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let pm100Label: UILabel = {
        let label = UILabel()
        label.text = "Pm100"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let COLabel: UILabel = {
        let label = UILabel()
        label.text = "CO"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let temperatureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "thermometer").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    let pressureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pressure").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    let humidityImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "humidity").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.deviceImageView, self.localizationLabel])
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy var sensorStackView: UIStackView = {
        let stackViewTemperature = UIStackView(arrangedSubviews: [self.temperatureImageView, self.temperatureLabel])
        stackViewTemperature.distribution = .fill
        stackViewTemperature.alignment = .center
        stackViewTemperature.axis = .vertical
        stackViewTemperature.layer.borderColor = UIColor.black.cgColor
        stackViewTemperature.layer.borderWidth = 5
        
        let stackViewPressure = UIStackView(arrangedSubviews: [self.pressureImageView, self.pressureLabel])
        stackViewPressure.distribution = .fill
        stackViewPressure.alignment = .center
        stackViewPressure.axis = .vertical
        stackViewPressure.backgroundColor = UIColor.init(white: 0.6, alpha: 1.0)
        
        let stackViewHumidity = UIStackView(arrangedSubviews: [self.humidityImageView, self.humidityLabel])
        stackViewHumidity.distribution = .equalSpacing
        stackViewHumidity.alignment = .center
        stackViewHumidity.axis = .vertical
        stackViewHumidity.backgroundColor = UIColor.init(white: 0.6, alpha: 1.0)
        
        
        
        let stackViewTop = UIStackView(arrangedSubviews: [stackViewTemperature, stackViewPressure, stackViewHumidity])
        stackViewTop.distribution = .fillEqually
        stackViewTop.alignment = .fill
        stackViewTop.axis = .horizontal
        stackViewTop.spacing = 10
        
        let stackViewCenter = UIStackView(arrangedSubviews: [self.pm10Label, self.pm25Label, self.pm100Label])
        stackViewCenter.distribution = .fillEqually
        stackViewCenter.alignment = .fill
        stackViewCenter.axis = .horizontal
        
        let stackViewBottom = UIStackView(arrangedSubviews: [self.COLabel])
        stackViewBottom.distribution = .fillEqually
        stackViewBottom.alignment = .fill
        stackViewBottom.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTop, stackViewCenter, stackViewBottom])
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func didMoveToSuperview() {
        self.backgroundColor = UIColor.init(white: 0.7, alpha: 0.5)
        self.addSubview(leftStackView)
        self.addSubview(sensorStackView)
        leftStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: self.frame.width/5, height: 0))
        sensorStackView.anchor(top: self.topAnchor, leading: leftStackView.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
}
