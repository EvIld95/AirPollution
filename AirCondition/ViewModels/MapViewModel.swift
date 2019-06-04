//
//  MapViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 14/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift

class MapViewModel: ViewModelType {
    var input: MapViewModel.Input
    var output: MapViewModel.Output
    
    struct Input {
    
    }
    
    struct Output {
        var devices = Variable<[DeviceModel]>([])
        
    }
    
    init() {
        self.input = Input()
        self.output = Output()
        
        for i in 1..<10 {
            self.output.devices.value.append(DeviceModel(serial: String(i), pm10: i, pm25: i*2, pm100: i*9, pressure: 1015, temperature: 16, humidity: 75, CO: Double(i) * 80.0, latitude: 52.0 + Double.random(in: 0.0..<1.0), longitude: 16.5 + Double.random(in: 0.0..<0.5) ))
        }
    }
    
}
