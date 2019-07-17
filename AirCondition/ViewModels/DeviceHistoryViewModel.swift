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
