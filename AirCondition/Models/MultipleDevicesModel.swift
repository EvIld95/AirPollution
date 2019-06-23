
//
//  MultipleDevicesModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 18/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//


import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class MultipleDevicesModel : ALSwiftyJSONAble {
    
    var array = [Device]()
    required init?(jsonData:JSON){
        for device in jsonData.array! {
            let serial = device["serial"].string
            let email =  device["email"].string
            let latitude = device["latitude"].double
            let longitude = device["longitude"].double
            let dev = Device(email: email, serial: serial, latitude: latitude, longitude: longitude)
            array.append(dev)
        }
    }
}

struct Device {
    let email: String?
    let serial: String?
    let latitude: Double?
    let longitude: Double?
}
