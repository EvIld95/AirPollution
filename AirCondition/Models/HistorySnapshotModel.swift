//
//  HistorySnapshotModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 08/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class HistorySnapshotModel : ALSwiftyJSONAble {
    
    var array = [SensorData]()
    required init?(jsonData:JSON){
        for snap in jsonData.array! {
            let createdOn = snap["createdOn"].string
            let humidity = snap["humidity"].double
            let serial = snap["serial"].string
            let latitude = snap["latitude"].double
            let longitude = snap["longitude"].double
            let CO = snap["CO"].int
            let pm10 = snap["pm10"].int
            let pm25 = snap["pm25"].int
            let pm100 = snap["pm100"].int
            let temperature = snap["temperature"].double
            let pressure = snap["pressure"].double
            let data = SensorData(humidity: humidity, serial: serial, latitude: latitude, longitude: longitude, CO: CO, pm10: pm10, pm25: pm25, pm100: pm100, temperature: temperature, pressure: pressure, createdOn: createdOn)
            array.append(data)
        }
    }
}
