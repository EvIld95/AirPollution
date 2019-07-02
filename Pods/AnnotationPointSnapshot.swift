//
//  AnnotationPointSnapshot.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 02/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import MapKit

class AnnotationPointSnapshot: MKPointAnnotation {
    let data: SensorData
    
    init(data: SensorData) {
        self.data = data
        super.init()
        self.coordinate.longitude = data.longitude!
        self.coordinate.latitude = data.latitude!

    }
}
