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
        var showDeviceHistoryWithSerial = Variable<String>("")
    }
    
    struct Output {
        fileprivate(set) var devices = Variable<[DeviceModel]>([])
        var deviceStream: Observable<DeviceModel>!
        var logout = Variable<Bool>(false)
        var userLocation = Variable<CLLocation?>(nil)
        var trackDevice = Variable<DeviceModel?>(nil)
        var currentlyTrackingID: Int? = nil //id received from database
    }
    
    func addNewDevice(dev: DeviceModel) {
        self.output.devices.value.append(dev)
    }
    
    @objc func addNewDeviceToDatabase(serial:String, onError: @escaping () -> ()) {
        self.appManager.checkIfDeviceExists(serial: serial) { (exists) in
            guard exists == true else { onError(); return }
            guard let location = self.output.userLocation.value, let email = Auth.auth().currentUser?.email else { return }
            
            self.appManager.addNewDevice(serial: serial, email: email, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, completion: { device in
                self.addNewDevice(dev: device)
            }, onError: {
                onError()
            }
            )
        }
    }
    
    func startTracking(device: DeviceModel) {
        self.appManager.addTracking(serial: device.serial.value!) { trackingModel in
            for dev in self.output.devices.value {
                dev.isTracked.value = false
            }
            device.isTracked.value = true
            self.output.trackDevice.value = device
            self.output.currentlyTrackingID = trackingModel.id
        }
    }
    
    func stopTracking(device: DeviceModel) {
        device.isTracked.value = false
        self.output.trackDevice.value = nil
        self.output.currentlyTrackingID = nil
    }
    
    func getAllDevices(onError: @escaping () -> ()) {
        self.appManager.getAllDevices(completion: { devices in
            for dev in devices {
                guard let deviceModel = DeviceModel(device: dev) else { continue }
                self.addNewDevice(dev: deviceModel)
            }
        }, onError: {
            onError()
        } )
    }
    
    init() {
        self.input = Input()
        self.output = Output()
        self.output.deviceStream = self.output.devices.asObservable().flatMap({ (devices) -> Observable<DeviceModel> in
            return Observable.from(devices)
        })
        
        
        Observable.combineLatest(self.output.trackDevice.asObservable(), self.output.userLocation.asObservable().throttle(5, scheduler: MainScheduler.instance)) { device, location -> (DeviceModel?, CLLocation?) in
            return (device,location)
            }.filter({ tuple -> Bool in
                return tuple.0 != nil && tuple.1 != nil && self.output.currentlyTrackingID != nil
            }).subscribe(onNext: { tuple in
            let device = tuple.0
            let location = tuple.1
            self.appManager.addSnapshot(serial: device!.serial.value!, trackingId: self.output.currentlyTrackingID!, temperature: device!.temperature.value!, pressure: device!.pressure.value!, humidity: device!.humidity.value!, pm10: device!.pm10.value ?? 0, pm100: device!.pm100.value ?? 0, pm25: device!.pm25.value ?? 0, CO: device!.CO.value ?? 0.0, location: location!, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
}
