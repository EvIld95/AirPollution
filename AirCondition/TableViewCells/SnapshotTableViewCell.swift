//
//  SnapshotTableViewCell.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 23/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class SnapshotTableViewCell: UITableViewCell {
    
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
