//
//  DevicesCollectionViewHeader.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 04/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation

class DevicesCollectionViewHeader: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var device: DeviceModel! {
        didSet {
            if(device.CO.value == nil) {
                self.deviceImageView.image = #imageLiteral(resourceName: "airlyDevice").withRenderingMode(.alwaysOriginal)
            } else {
                self.deviceImageView.image = #imageLiteral(resourceName: "device1").withRenderingMode(.alwaysOriginal)
            }
            self.setupRx()
        }
    }
    
    let deviceImageView: UIImageView = {
        let div = UIImageView(image: #imageLiteral(resourceName: "device1").withRenderingMode(.alwaysOriginal))
        div.contentMode = .scaleAspectFit
        div.clipsToBounds = true
        return div
    }()
    
    let localizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Poznan"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    
    func setupRx() {
        device.address.subscribe(onNext: { address in
            self.localizationLabel.text = address
        }).disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2)
        self.addSubview(deviceImageView)
        self.addSubview(localizationLabel)
        deviceImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 2, left: 16, bottom: 2, right: 0), size: .init(width: 50, height: 0))
        localizationLabel.anchor(top: topAnchor, leading: deviceImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: 8, bottom: 2, right: 2))
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
