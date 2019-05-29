//
//  AnnotationPointDevice.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 29/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import MapKit

class AnnotationPointDevice: MKPointAnnotation {
    let device: DeviceModel
    
    init(device: DeviceModel) {
         self.device = device
         super.init()
    }
}
