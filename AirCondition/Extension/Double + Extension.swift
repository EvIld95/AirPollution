//
//  Double + Extension.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 08/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
