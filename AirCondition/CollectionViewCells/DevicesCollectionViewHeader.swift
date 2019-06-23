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

protocol DevicesSelectableToTrackDelegate {
    func didSelectDeviceToTrack(device: DeviceModel)
}

class DevicesCollectionViewHeader: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var delegate: DevicesSelectableToTrackDelegate!
    
    var device: DeviceModel! {
        didSet {
            if(device.CO.value == nil) {
                self.deviceImageView.image = #imageLiteral(resourceName: "airlyDevice").withRenderingMode(.alwaysOriginal)
                self.buttonTrack.isHidden = true
            } else {
                self.deviceImageView.image = #imageLiteral(resourceName: "device1").withRenderingMode(.alwaysOriginal)
                self.buttonTrack.isHidden = false
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
    
    let serialLabel: UILabel = {
        let label = UILabel()
        label.text = "serial"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var buttonTrack: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Track", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(trackHandler), for: .touchUpInside)
        return button
    }()
    
    @objc func trackHandler() {
        self.delegate.didSelectDeviceToTrack(device: device)
    }

    
    func setupRx() {
        device.address.subscribe(onNext: { address in
            self.localizationLabel.text = address
        }).disposed(by: disposeBag)
        
        device.serial.asDriver().drive(self.serialLabel.rx.text).disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2)
        self.addSubview(deviceImageView)
        self.addSubview(localizationLabel)
        self.addSubview(serialLabel)
        self.addSubview(buttonTrack)
        deviceImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 2, left: 16, bottom: 2, right: 0), size: .init(width: 50, height: 0))
        localizationLabel.anchor(top: topAnchor, leading: deviceImageView.trailingAnchor, bottom: nil, trailing: buttonTrack.leadingAnchor, padding: .init(top: 2, left: 8, bottom: 0, right: 2), size: .init(width: 0, height: 25))
        serialLabel.anchor(top: localizationLabel.bottomAnchor, leading: deviceImageView.trailingAnchor, bottom: bottomAnchor, trailing: buttonTrack.leadingAnchor , padding: .init(top: 2, left: 8, bottom: 2, right: 2))
        buttonTrack.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 8), size: .init(width: 60, height: 0))
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
