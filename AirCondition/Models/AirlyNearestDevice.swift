//
//  AirlyNearestDevice.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 05/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class AirlyNearestDevice : ALSwiftyJSONAble {
    
    var array = [NearestDevice]()
    required init?(jsonData:JSON){
        print(jsonData)
        for device in jsonData.array! {
            let id = device["id"].int
            let street = device["address"]["street"].string
            let city =  device["address"]["city"].string
            let latitude = device["location"]["latitude"].double
            let longitude = device["location"]["longitude"].double
            let nearestDevice = NearestDevice(city: city, street: street, id: id, latitude: latitude, longitude: longitude)
            array.append(nearestDevice)
        }
    }
}

struct NearestDevice {
    let city: String?
    let street: String?
    let id: Int?
    let latitude: Double?
    let longitude: Double?
}
