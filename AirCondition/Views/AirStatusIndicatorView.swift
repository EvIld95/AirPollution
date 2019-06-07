//
//  AirStatusIndicatorView.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 29/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit

enum AirQuality {
    case normal
    case bad
    case alarm
}

class AirStatusIndicatorView: UIView {

    let device: DeviceModel!
    init(device: DeviceModel) {
        self.device = device
        super.init(frame: .init(x: 0, y: 0, width: 15, height: 15))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(ovalIn: rect)
        
       
        
        switch calculateAirQuality() {
            case .normal:
                UIColor.green.setFill()
            case .bad:
                UIColor.orange.setFill()
            case .alarm:
                UIColor.red.setFill()
        }
  
        bezierPath.fill()

        
    }
 
    func getImage() -> UIImage {
        let image = UIGraphicsImageRenderer(size: bounds.size).image { _ in
            self.draw(bounds)
        }
        return image
    }
    
    func calculateAirQuality() -> AirQuality {
        let pm100 = device.pm100.value!
        let pm25 = device.pm25.value!
        
        if pm25 < 25 && pm100 < 50 {
            return .normal
        } else if pm100 < 200 {
            return .bad
        } else {
            return .alarm
        }
    }

}
