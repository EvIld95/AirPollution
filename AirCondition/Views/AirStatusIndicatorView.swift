//
//  AirStatusIndicatorView.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 29/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class AirStatusIndicatorView: UIView {

    let device: DeviceModel!
    init(device: DeviceModel) {
        self.device = device
        super.init(frame: .init(x: 0, y: 0, width: 20, height: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(ovalIn: rect)
        
        if(device.pm100 < 50) {
            UIColor.green.setFill()
        } else {
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

}
