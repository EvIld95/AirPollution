//
//  TrackingHistoryViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 23/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import Firebase
import MapKit

class TrackingHistoryViewModel: ViewModelType {
    var input: TrackingHistoryViewModel.Input
    var output: TrackingHistoryViewModel.Output
    let disposeBag = DisposeBag()
    var appManager: AppManager!
    
    struct Input {
        var selectedSnapshots = Variable<[SensorData]>([])
    }
    
    struct Output {
        var trackingSnapshots = Variable<[Int: [SensorData]]>([Int: [SensorData]]())
    }
    
    func getAllTrackingSnapshots(onError: @escaping () -> ()) {
        self.appManager.getAllTrackingSnapshots(completion: { (snapshotsDict) in
            for id in snapshotsDict.keys {
                self.output.trackingSnapshots.value[id] = snapshotsDict[id]
            }
        }, onError: { onError() })
    }
    
    
    init() {
        self.input = Input()
        self.output = Output()
    }
    
}
