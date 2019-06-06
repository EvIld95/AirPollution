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

class DeviceModel {
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
        self.serial.value = serial
        self.pm10.value = pm10
        self.pm25.value = pm25
        self.pm100.value = pm100
        self.pressure.value = pressure
        self.temperature.value = temperature
        self.humidity.value = humidity
        self.CO.value = CO
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(deviceAirly: AirlyDeviceSensor) {
        self.serial.value = nil
        self.pm10.value = Int(deviceAirly.pm10!)
        self.pm25.value = Int(deviceAirly.pm25!)
        self.pm100.value = Int(deviceAirly.pm100!)
        self.pressure.value = deviceAirly.pressure
        self.temperature.value = deviceAirly.temperature
        self.humidity.value = deviceAirly.humidity
        self.CO.value = nil
        self.latitude.value = deviceAirly.deviceAirly!.latitude!
        self.longitude.value = deviceAirly.deviceAirly!.longitude!
    }
    
    func listenForDeviceUpdates() {
        guard let id = self.serial.value else { return }
        let ref = Database.database().reference().child("airDevice").child(id)
        ref.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                print(dict)
                
                self.humidity.value = (dict["Humidity"]! as! Double)
                self.pm10.value = (dict["PM10"]! as! Int)
                self.pm25.value = (dict["PM25"]! as! Int)
                self.pm100.value = (dict["PM100"]! as! Int)
                self.pressure.value = (dict["Pressure"]! as! Double)
                self.temperature.value = (dict["Temp"] as! Double)
                
            }
        })
    }
    
}
