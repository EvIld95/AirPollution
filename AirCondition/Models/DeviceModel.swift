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
import FirebaseDatabase
import Firebase
import Moya_SwiftyJSONMapper
import SwiftyJSON

class DeviceModel {
    let disposeBag = DisposeBag()
    var email: String?
    var serial: Variable<String?> = Variable<String?>(nil)
    var pm10: Variable<Int?> = Variable<Int?>(nil)
    var pm25: Variable<Int?> = Variable<Int?>(nil)
    var pm100: Variable<Int?> = Variable<Int?>(nil)
    var pressure: Variable<Double?> = Variable<Double?>(nil)
    var temperature: Variable<Double?> = Variable<Double?>(nil)
    var humidity: Variable<Double?> = Variable<Double?>(nil)
    var CO: Variable<Double?> = Variable<Double?>(nil)
    var latitude: Variable<Double> = Variable<Double>(0.0)
    var longitude: Variable<Double> = Variable<Double>(0.0)
    var isTracked: Variable<Bool> = Variable<Bool>(false)
    var address: Observable<String> {
        get {
            return Observable.zip([latitude.asObservable(), longitude.asObservable()]).flatMap({ (geo) -> Observable<String> in
                let lat = geo[0]
                let lon = geo[1]
                return self.getAddressFromLatLon(lat: lat, withLongitude: lon)
            })
        }
    }
    var addressVariable = Variable<String>("")
    
    var airQualityChanged: Observable<DeviceModel>!
    
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
    
    private init(serial: String?, latitude: Double, longitude: Double, email: String?) {
        self.serial.value = serial
        self.pm10.value = 0
        self.pm25.value = 0
        self.pm100.value = 0
        self.pressure.value = 0
        self.temperature.value = 0
        self.humidity.value = 0
        self.CO.value = 0
        self.latitude.value = latitude
        self.longitude.value = longitude
        self.email = email
        self.isTracked.value = false
        self.setupRx()
    }
    
    init(deviceAirly: AirlyDeviceSensor) {
        self.serial.value = "\(deviceAirly.deviceAirly?.id)"//serial
        self.pm10.value = Int(deviceAirly.pm10 ?? 0)
        self.pm25.value = Int(deviceAirly.pm25 ?? 0)
        self.pm100.value = Int(deviceAirly.pm100 ?? 0)
        self.pressure.value = deviceAirly.pressure
        self.temperature.value = deviceAirly.temperature
        self.humidity.value = deviceAirly.humidity
        self.CO.value = nil
        self.email = nil
        self.latitude.value = deviceAirly.deviceAirly!.latitude!
        self.longitude.value = deviceAirly.deviceAirly!.longitude!
        self.isTracked.value = false
        self.setupRx()
    }
    
    convenience init?(device: Device) {
        guard let latitude = device.latitude, let longitude = device.longitude else { return nil }
        self.init(serial: device.serial, latitude: latitude, longitude: longitude, email: device.email)
    }
    
    func setupRx() {
        self.airQualityChanged = Observable.merge([pm100.asObservable(), pm25.asObservable(), isTracked.asObservable().map({ tracked -> Int? in return tracked ? 1 : 0}) ]).map { (value) -> DeviceModel in
            return self
        }
        self.address.bind(to: addressVariable).disposed(by: disposeBag)
        listenForDeviceUpdates()
    }
    
    private func listenForDeviceUpdates() {
        guard let id = self.serial.value, let _ = self.email, let _ = self.CO.value else { return }
        let ref = Database.database().reference().child("airDevice").child(id)
        ref.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.humidity.value = (dict["Humidity"]! as! Double)
                self.pm10.value = (dict["PM10"]! as! Int)
                self.pm25.value = (dict["PM25"]! as! Int)
                self.pm100.value = (dict["PM100"]! as! Int)
                self.pressure.value = (dict["Pressure"]! as! Double)
                self.temperature.value = (dict["Temp"] as! Double)
                self.CO.value = (dict["CO"] as! Double)
                
            }
        })
    }
    
}
