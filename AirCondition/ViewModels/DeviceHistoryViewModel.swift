//
//  DeviceHistoryViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 08/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import Firebase
import MapKit

class DeviceHistoryViewModel: ViewModelType {
    var input: DeviceHistoryViewModel.Input
    var output: DeviceHistoryViewModel.Output
    let disposeBag = DisposeBag()
    var appManager: AppManager!
    
    struct Input {
        var serial = Variable<String?>(nil)
    }
    
    struct Output {
        var historySnapshots = Variable<[SensorData]>([])
        var filteredSnapshots = Variable<[SensorData]>([])
    }
    
    private func getHistorySnaps(serial: String) -> Observable<[SensorData]> {
        return Observable<[SensorData]>.create { (obs) -> Disposable in
            self.appManager.getHistorySnapshots(serial: serial, completion: { (data) in
                var data = data
                
                for _ in 0..<100 {
                    let dateRandString = "2019-0\(Int.random(in: 7 ..< 8))-\(Int.random(in: 1 ..< 30)) 22:00:00"
                    data.append(SensorData(humidity: Double.random(in: 0.0 ..< 100.0), serial: "0000000076e88405", latitude: 27.33, longitude: 0.0, CO: Int.random(in: 0 ..< 10000), pm10: Int.random(in: 0 ..< 1000), pm25: Int.random(in: 0 ..< 1000), pm100: Int.random(in: 0 ..< 1000), temperature: Double.random(in: 0.0 ..< 40.0), pressure: Double.random(in: 950.0 ..< 1050.0), createdOn: dateRandString))
                }
                
                for _ in 0..<30 {
                    let dateRandString = "2019-08-02 \(Int.random(in: 10...17)):00:00"
                    data.append(SensorData(humidity: Double.random(in: 0 ..< 100.0), serial: "0000000076e88405", latitude: 27.33, longitude: 0.0, CO: Int.random(in: 0 ..< 10000), pm10: Int.random(in: 0 ..< 1000), pm25: Int.random(in: 0 ..< 1000), pm100: Int.random(in: 0 ..< 1000), temperature: Double.random(in: 0.0 ..< 40.0), pressure: Double.random(in: 950.0 ..< 1050.0), createdOn: dateRandString))
                }
                obs.onNext(data)
                obs.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    init() {
        self.input = Input()
        self.output = Output()
        self.output.historySnapshots.asObservable().bind(to: self.output.filteredSnapshots).disposed(by: disposeBag)
        self.input.serial.asObservable().filter { (serial) -> Bool in
            return serial != nil && serial != ""
            }.flatMap { (serial) in
                return self.getHistorySnaps(serial: serial!)
        }.bind(to: self.output.historySnapshots).disposed(by: disposeBag)
        
    }
}
