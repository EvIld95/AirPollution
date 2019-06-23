//
//  TrackingModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 23/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//


import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class TrackingModel : ALSwiftyJSONAble {
    let id: Int?
    required init?(jsonData:JSON){
        print(jsonData)
        self.id = jsonData["id"].int
    }
}
