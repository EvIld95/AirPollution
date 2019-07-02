//
//  TrackingSnapshotModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 25/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class TrackingSnapshotModel : ALSwiftyJSONAble {
    
    var dict = [Int: [SensorData]]()
    required init?(jsonData:JSON){
        for snap in jsonData.array! {
            let id = snap["id"].int!
            let createdOn = snap["createdOn"].string
            
            let array =  snap["array"].array!
            for sensorData in array {
                let humidity = sensorData["humidity"].double
                let serial = sensorData["serial"].string
                let latitude = sensorData["latitude"].double
                let longitude = sensorData["longitude"].double
                let CO = sensorData["CO"].int
                let pm10 = sensorData["pm10"].int
                let pm25 = sensorData["pm25"].int
                let pm100 = sensorData["pm100"].int
                let temperature = sensorData["temperature"].double
                let pressure = sensorData["pressure"].double
                let data = SensorData(humidity: humidity, serial: serial, latitude: latitude, longitude: longitude, CO: CO, pm10: pm10, pm25: pm25, pm100: pm100, temperature: temperature, pressure: pressure, createdOn: createdOn)
                if dict[id] == nil {
                    dict[id] = [SensorData]()
                }
                
                dict[id]?.append(data)
            }
        }
    }
}

struct SensorData {
    let humidity: Double?
    let serial: String?
    let latitude: Double?
    let longitude: Double?
    let CO: Int?
    let pm10: Int?
    let pm25: Int?
    let pm100: Int?
    let temperature: Double?
    let pressure: Double?
    let createdOn: String?
}
