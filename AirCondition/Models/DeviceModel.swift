//
//  DeviceModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation

struct DeviceModel {
    var serial: String!
    var pm10: Int!
    var pm25: Int!
    var pm100: Int!
    var pressure: Float!
    var temperature: Float!
    var humidity: Float!
    var CO: Float!
    var latitude: Double!
    var longitude: Double!
}
