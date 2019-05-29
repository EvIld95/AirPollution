//
//  DevicesListViewModel.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//


import Foundation
import RxSwift

class DevicesListViewModel: ViewModelType {
    var input: DevicesListViewModel.Input
    var output: DevicesListViewModel.Output
    
    struct Input {
        
    }
    
    struct Output {
        var devices = Variable<[DeviceModel]>([])
    }
    
    init() {
        self.input = Input()
        self.output = Output()
    }
    
}
