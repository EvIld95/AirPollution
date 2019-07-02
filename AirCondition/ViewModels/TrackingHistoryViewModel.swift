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
        
    }
    
    struct Output {
        var trackingSnapshots = Variable<[Int: [SensorData]]>([Int: [SensorData]]())
        var selectedSnapshots = Variable<[SensorData]>([])
    }
    
    func getAllTrackingSnapshots() {
        self.appManager.getAllTrackingSnapshots { (snapshotsDict) in
            for id in snapshotsDict.keys {
                self.output.trackingSnapshots.value[id] = snapshotsDict[id]
            }
        }
    }
    
    
    init() {
        self.input = Input()
        self.output = Output()
        
        
    }
    
}
