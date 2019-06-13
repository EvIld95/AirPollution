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
import Firebase
import MapKit

class MapViewModel: ViewModelType {
    var input: MapViewModel.Input
    var output: MapViewModel.Output
    let disposeBag = DisposeBag()
    var appManager: AppManager!
    
    struct Input {
    
    }
    
    struct Output {
        fileprivate(set) var devices = Variable<[DeviceModel]>([])
        var deviceStream: Observable<DeviceModel>!
        var logout = Variable<Bool>(false)
        var userLocation = Variable<CLLocation?>(nil)
        var trackDevice = Variable<DeviceModel?>(nil)
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
        
        
        let testDevice = DeviceModel(serial: "0000000076e88405", pm10: 1, pm25: 2, pm100: 9, pressure: 1015, temperature: 16, humidity: 75, CO: Double(1) * 80.0, latitude: .init(52.0 + Double.random(in: 0.0..<1.0)), longitude: .init(16.5 + Double.random(in: 0.0..<0.5)), userId: Auth.auth().currentUser?.uid)
        
        self.output.devices.value.append(testDevice)
        testDevice.listenForDeviceUpdates()
        
        Observable.combineLatest(self.output.trackDevice.asObservable(), self.output.userLocation.asObservable()) { device, location -> (DeviceModel?, CLLocation?) in
            return (device,location)
            }.skipWhile({ tuple -> Bool in
                return tuple.0 == nil || tuple.1 == nil
            }).subscribe(onNext: { tuple in
            let device = tuple.0
            let location = tuple.1
            self.appManager.addSnapshot(serial: device!.serial.value!, temperature: device!.temperature.value!, pressure: device!.pressure.value!, humidity: device!.humidity.value!, pm10: device!.pm10.value ?? 0, pm100: device!.pm100.value ?? 0, pm25: device!.pm25.value ?? 0, CO: device!.CO.value ?? 0.0, location: location!, completion: nil)
        }).disposed(by: disposeBag)
        
        
        
    
//        for i in 1..<10 {
//            self.output.devices.value.append(DeviceModel(serial: String(i), pm10: i, pm25: i*2, pm100: i*9, pressure: 1015, temperature: 16, humidity: 75, CO: Double(i) * 80.0, latitude: .init(52.0 + Double.random(in: 0.0..<1.0)), longitude: .init(16.5 + Double.random(in: 0.0..<0.5))))
//        }
        
    }
    
}
