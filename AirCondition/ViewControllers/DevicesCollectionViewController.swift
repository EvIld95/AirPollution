//
//  DevicesCollectionViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit

enum DevicesCollectionCellIDs: String {
    case device
}

class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: DevicesListViewModel!
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4//viewModel.output.devices.value.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        if let cvLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            cvLayout.scrollDirection = .vertical
        }
        
        self.collectionView.backgroundView = setupGradientLayer()
        self.collectionView.register(DevicesCollectionViewCell.self, forCellWithReuseIdentifier: DevicesCollectionCellIDs.device.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DevicesCollectionCellIDs.device.rawValue, for: indexPath) as! DevicesCollectionViewCell
        cell.backgroundColor = .clear
        return cell
    }

    
    func setupGradientLayer() -> UIView {
        let viewBG = UIView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 76.0/255.0, green: 130.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 85.0/255.0, green: 159.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        // make sure to user cgColor
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.locations = [0, 1.5]
        gradientLayer.frame = viewBG.bounds
        viewBG.layer.addSublayer(gradientLayer)
        return viewBG
    }
    
}
