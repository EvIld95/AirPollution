//
//  MapViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 14/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation


class MapViewModel: ViewModelType {
    var input: MapViewModel.Input
    var output: MapViewModel.Output
    let disposeBag = DisposeBag()
    struct Input {
    
    }
    
    struct Output {
        fileprivate(set) var devices = Variable<[DeviceModel]>([])
        var deviceStream: Observable<DeviceModel>!
        var logout = Variable<Bool>(false)
        //var PMs = Observable<[Int?]>([])
        
    }
    
    func addNewDevice(dev: DeviceModel) {
        self.output.devices.value.append(dev)
    }
    
    init() {
        self.input = Input()
        self.output = Output()
        self.output.deviceStream = self.output.devices.asObservable().flatMap({ (devices) -> Observable<DeviceModel> in
            return Observable.from(devices)
        })
        
        
        let testDevice = DeviceModel(serial: "0000000076e88405", pm10: 1, pm25: 1*2, pm100: 1*9, pressure: 1015, temperature: 16, humidity: 75, CO: Double(1) * 80.0, latitude: .init(52.0 + Double.random(in: 0.0..<1.0)), longitude: .init(16.5 + Double.random(in: 0.0..<0.5)))
        
        self.output.devices.value.append(testDevice)
        testDevice.listenForDeviceUpdates()
        
    
//        for i in 1..<10 {
//            self.output.devices.value.append(DeviceModel(serial: String(i), pm10: i, pm25: i*2, pm100: i*9, pressure: 1015, temperature: 16, humidity: 75, CO: Double(i) * 80.0, latitude: .init(52.0 + Double.random(in: 0.0..<1.0)), longitude: .init(16.5 + Double.random(in: 0.0..<0.5))))
//        }
        
    }
    
}
