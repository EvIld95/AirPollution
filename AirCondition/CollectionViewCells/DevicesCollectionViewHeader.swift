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
    var latitude = Variable<Double>(0.0)
    var longitude = Variable<Double>(0.0)
    
    let deviceImageView: UIImageView = {
        let div = UIImageView(image: #imageLiteral(resourceName: "device").withRenderingMode(.alwaysOriginal))
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
    
    func getAddressFromLatLon(lat: Double, withLongitude lon: Double) {
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    let locality = (pm.locality != nil ? "\(pm.locality!)" : "")
                    self.localizationLabel.text = locality + (pm.thoroughfare != nil ? ", \(pm.thoroughfare!)" : "")
                }
        })
    }
    
    func setupRx() {
        Observable.zip([latitude.asObservable(), longitude.asObservable()]).subscribe(onNext: { geo in
            let lat = geo[0]
            let lon = geo[1]
            self.getAddressFromLatLon(lat: lat, withLongitude: lon)
        }).disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupRx()
        
        self.addSubview(deviceImageView)
        self.addSubview(localizationLabel)
        deviceImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 2, left: 16, bottom: 2, right: 0), size: .init(width: 50, height: 0))
        localizationLabel.anchor(top: topAnchor, leading: deviceImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: 8, bottom: 2, right: 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
