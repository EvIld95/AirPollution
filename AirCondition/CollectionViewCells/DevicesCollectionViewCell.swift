//
//  DevicesCollectionViewCell.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import M13ProgressSuite
import RxSwift

class DevicesCollectionViewCell: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var device: DeviceModel!
    lazy var progressBorderedCO : M13ProgressViewBorderedBar = {
        let bar =  M13ProgressViewBorderedBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        
        bar.cornerType = M13ProgressViewBorderedBarCornerTypeRounded
        bar.cornerRadius = 8.0
        bar.animationDuration = 1.5
        bar.primaryColor = .green
        bar.secondaryColor = .clear
        bar.setProgress(0.5, animated: true)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return bar
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = "1012hPa"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "88%"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "12C"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let pm10Label: UILabel = {
        let label = UILabel()
        label.text = "Pm10"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let pm25Label: UILabel = {
        let label = UILabel()
        label.text = "Pm25"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let pm100Label: UILabel = {
        let label = UILabel()
        label.text = "Pm100"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let COLabel: UILabel = {
        let label = UILabel()
        label.text = "CO: "
        //label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }()
    
    private let temperatureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-thermometer-50").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let pressureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-pressure-gauge-50").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let humidityImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-humidity-50").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        let stackViewBottom = UIStackView(arrangedSubviews: [self.COLabel, self.progressBorderedCO])
        stackViewBottom.distribution = UIStackView.Distribution.fill
        stackViewBottom.alignment = .leading
        stackViewBottom.axis = .horizontal
        stackViewBottom.spacing = 10
        stackViewBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackViewBottom.isLayoutMarginsRelativeArrangement = true
        stackViewBottom.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        stackViewBottom.isHidden = true
        return stackViewBottom
    }()
    
    private lazy var sensorStackView: UIStackView = {
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
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTop, stackViewCenter, stackViewBottom])
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .vertical
        
        return stackView
    }()

    override func didMoveToSuperview() {
        self.setupRx()
        self.addSubview(sensorStackView)
        sensorStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func setupRx() {
        device.temperature.asDriver().map({ (value) -> String in value == nil ? "No data" :"\(value!.roundTo(places: 2)) C" }).drive(self.temperatureLabel.rx.text).disposed(by: disposeBag)
        device.humidity.asDriver().map({ (value) -> String in value == nil ? "No data" :"\(value!.roundTo(places: 2)) %" }).drive(self.humidityLabel.rx.text).disposed(by: disposeBag)
        device.pressure.asDriver().map({ (value) -> String in value == nil ? "No data" :"\(value!.roundTo(places: 2)) hPa" }).drive(self.pressureLabel.rx.text).disposed(by: disposeBag)
        device.pm10.asDriver().map({ (value) -> String in "PM1.0: \(value!)" }).drive(self.pm10Label.rx.text).disposed(by: disposeBag)
        device.pm100.asDriver().map({ (value) -> String in "PM10: \(value!)" }).drive(self.pm100Label.rx.text).disposed(by: disposeBag)
        device.pm25.asDriver().map({ (value) -> String in "PM2.5: \(value!)" }).drive(self.pm25Label.rx.text).disposed(by: disposeBag)
        device.CO.asObservable().map({ (value) -> Double in
            self.COLabel.text = "CO: \(value ?? 0) ppm"
            let newVal = (Double(value ?? 0.0) / 400.0)
            return newVal > 1.0 ? 1.0 : newVal
        }).subscribe(onNext: { value in
            self.progressBorderedCO.setProgress(CGFloat(value), animated: true)
            self.progressBorderedCO.primaryColor = UIColor(hue: CGFloat(0.33 - ((value) * 0.33)), saturation: 1, brightness: 1, alpha: 1)
        }).disposed(by: disposeBag)
    }
    
    func hideProgressBar(hide: Bool) {
        self.stackViewBottom.isHidden = hide
    }
    
}
