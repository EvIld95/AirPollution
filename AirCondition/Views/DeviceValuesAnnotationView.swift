//
//  DeviceValuesAnnotationView.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 06/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

protocol DeviceValuesViewDelegate {
    func viewTapped()
}

class DeviceValuesView: UIView {
    let disposeBag = DisposeBag()
    var delegate: DeviceValuesViewDelegate!
    
    var typeOfDevice: String = "" {
        didSet {
            self.typeOfDeviceLabel.text = typeOfDevice
        }
    }
    
    var temperature: Double = 0.0 {
        didSet {
            self.temperatureLabel.text = "\(temperature) C"
        }
    }
    
    var humidity: Double = 0.0 {
        didSet {
            self.humidityLabel.text = "\(humidity) %"
        }
    }
    
    var pressure: Double = 0.0 {
        didSet {
            self.pressureLabel.text = "\(pressure) hPa"
        }
    }
    
    var pm10: Int = 0 {
        didSet {
            self.pm10Label.text = "PM1.0: \(pm10)"
        }
    }
    
    var pm25: Int = 0 {
        didSet {
            self.pm25Label.text = "PM2.5: \(pm25)"
        }
    }
    
    var pm100: Int = 0 {
        didSet {
            self.pm100Label.text = "PM10: \(pm100)"
        }
    }
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = "1012hPa"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "88%"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "12C"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let pm10Label: UILabel = {
        let label = UILabel()
        label.text = "Pm10"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let pm25Label: UILabel = {
        let label = UILabel()
        label.text = "Pm25"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let pm100Label: UILabel = {
        let label = UILabel()
        label.text = "Pm100"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let COLabel: UILabel = {
        let label = UILabel()
        label.text = "CO: "
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    private let typeOfDeviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Device"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var sensorStackView: UIStackView = {
    
        let stackViewSensors = UIStackView(arrangedSubviews: [self.temperatureLabel, self.pressureLabel, self.humidityLabel])
        stackViewSensors.distribution = .fillEqually
        stackViewSensors.alignment = .fill
        stackViewSensors.axis = .horizontal
        stackViewSensors.spacing = 10
        
        let stackViewPM = UIStackView(arrangedSubviews: [self.pm10Label, self.pm25Label, self.pm100Label])
        stackViewPM.distribution = .fillEqually
        stackViewPM.alignment = .fill
        stackViewPM.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [typeOfDeviceLabel, stackViewSensors, stackViewPM])
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .vertical
        
        return stackView
    }()
    

    init(device: DeviceModel, frame: CGRect) {
        
        device.temperature.asDriver().map({ (value) -> String in "\(value!.roundTo(places: 2)) C" }).drive(self.temperatureLabel.rx.text).disposed(by: disposeBag)
        device.humidity.asDriver().map({ (value) -> String in "\(value!.roundTo(places: 2)) %" }).drive(self.humidityLabel.rx.text).disposed(by: disposeBag)
        device.pressure.asDriver().map({ (value) -> String in "\(value!.roundTo(places: 2)) hPa" }).drive(self.pressureLabel.rx.text).disposed(by: disposeBag)
        device.pm10.asDriver().map({ (value) -> String in "PM1.0: \(value!)" }).drive(self.pm10Label.rx.text).disposed(by: disposeBag)
        device.pm100.asDriver().map({ (value) -> String in "PM10: \(value!)" }).drive(self.pm100Label.rx.text).disposed(by: disposeBag)
        device.pm25.asDriver().map({ (value) -> String in "PM2.5: \(value!)" }).drive(self.pm25Label.rx.text).disposed(by: disposeBag)
      
        if device.CO.value == nil {
            self.typeOfDeviceLabel.text = "Airly"
        } else {
            self.typeOfDeviceLabel.text = "Raspberry"
        }
        
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        self.addSubview(sensorStackView)
        sensorStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched")
        delegate.viewTapped()
    }
}
