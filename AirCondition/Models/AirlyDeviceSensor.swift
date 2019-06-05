//
//  AirlyDeviceSensor.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 05/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class AirlyDeviceSensor : ALSwiftyJSONAble {
    var pm10: Double?
    var pm25: Double?
    var id: Int?
    var pm100: Double?
    var pressure: Double?
    var humidity: Double?
    var temperature: Double?
    
    convenience init?(jsonData: JSON, id: Int) {
        self.init(jsonData: jsonData)
        self.id = id
    }
    
    required init?(jsonData:JSON){
        let json = jsonData["current"]["values"]
        for data in json.array! {
            if(data["name"].string == "PM1") {
                self.pm10 = data["value"].double
            } else if(data["name"].string == "PM25") {
                self.pm25 = data["value"].double
            } else if(data["name"].string == "PM10") {
                self.pm100 = data["value"].double
            } else if(data["name"].string == "PRESSURE") {
                self.pressure = data["value"].double
            } else if(data["name"].string == "HUMIDITY") {
                self.humidity = data["value"].double
            } else if(data["name"].string == "TEMPERATURE") {
                self.temperature = data["value"].double
            }
        }
    }
}
