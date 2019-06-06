//
//  DeviceModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

struct DeviceModel {
    var serial: String?
    var pm10: Int!
    var pm25: Int!
    var pm100: Int!
    var pressure: Double!
    var temperature: Double!
    var humidity: Double!
    var CO: Double?
    var latitude: Variable<Double> = Variable<Double>(0.0)
    var longitude: Variable<Double> = Variable<Double>(0.0)
    
    var address: Observable<String> {
        get {
            return Observable.zip([latitude.asObservable(), longitude.asObservable()]).flatMap({ (geo) -> Observable<String> in
                let lat = geo[0]
                let lon = geo[1]
                return self.getAddressFromLatLon(lat: lat, withLongitude: lon)
            })
        }
    }
    
    private func getAddressFromLatLon(lat: Double, withLongitude lon: Double) -> Observable<String> {
        return Observable<String>.create { (obs) -> Disposable in
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        obs.onError(error!)
                    } else {
                        guard let pm = placemarks else { return }
                        
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            let locality = (pm.locality != nil ? "\(pm.locality!)" : "")
                            let text = locality + (pm.thoroughfare != nil ? ", \(pm.thoroughfare!)" : "")
                            obs.onNext(text)
                        }
                    }
                    obs.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    init(serial: String, pm10: Int, pm25: Int, pm100: Int, pressure: Double, temperature: Double, humidity: Double, CO: Double, latitude: Variable<Double>, longitude: Variable<Double>) {
        self.serial = serial
        self.pm10 = pm10
        self.pm25 = pm25
        self.pm100 = pm100
        self.pressure = pressure
        self.temperature = temperature
        self.humidity = humidity
        self.CO = CO
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(deviceAirly: AirlyDeviceSensor) {
        self.serial = nil
        self.pm10 = Int(deviceAirly.pm10!)
        self.pm25 = Int(deviceAirly.pm25!)
        self.pm100 = Int(deviceAirly.pm100!)
        self.pressure = deviceAirly.pressure
        self.temperature = deviceAirly.temperature
        self.humidity = deviceAirly.humidity
        self.CO = nil
        self.latitude.value = deviceAirly.deviceAirly!.latitude!
        self.longitude.value = deviceAirly.deviceAirly!.longitude!
    }
    
}
