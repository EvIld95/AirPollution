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
    var serial: String!
    var pm10: Int!
    var pm25: Int!
    var pm100: Int!
    var pressure: Double!
    var temperature: Double!
    var humidity: Double!
    var CO: Double!
    var latitude: Variable<Double>
    var longitude: Variable<Double>
    
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
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        let locality = (pm.locality != nil ? "\(pm.locality!)" : "")
                        let text = locality + (pm.thoroughfare != nil ? ", \(pm.thoroughfare!)" : "")
                        obs.onNext(text)
                    }
            })
            
            return Disposables.create()
        }
    }
    
}
