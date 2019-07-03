//
//  SnapshotTableViewCell.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 23/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class SnapshotTableViewCell: UITableViewCell {
    
    var data: SensorData! {
        didSet {
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude: data.latitude!, longitude: data.longitude!)
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    } else {
                        guard let pm = placemarks else { return }
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            let locality = (pm.locality != nil ? "\(pm.locality!)" : "")
                            let text = locality + (pm.thoroughfare != nil ? ", \(pm.thoroughfare!)" : "")
                            self.cityLabel.text = text
                        }
                    }
            })
        }
    }
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Poznan"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12.06.2019"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.dateLabel, self.cityLabel])
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    override func didMoveToSuperview() {
        self.addSubview(stackView)
        stackView.centerInSuperview()
    }

}
