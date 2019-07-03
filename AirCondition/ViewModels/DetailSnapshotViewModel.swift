//
//  DetailSnapshotViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 03/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//
import Foundation
import RxSwift
import CoreLocation
import Firebase
import MapKit

class DetailSnapshotViewModel: ViewModelType {
    var input: DetailSnapshotViewModel.Input
    var output: DetailSnapshotViewModel.Output
    let disposeBag = DisposeBag()
    var appManager: AppManager!
    
    struct Input {
        
    }
    
    struct Output {
        var selectedSnapshots = Variable<[SensorData]>([])
    }
    
    init() {
        self.input = Input()
        self.output = Output()
        
    }
}
