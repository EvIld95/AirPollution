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
    case header
}

class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: MapViewModel!
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.output.devices.value.count
    }
    
    
    override func viewDidLoad() {
        if let cvLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            cvLayout.scrollDirection = .vertical
        }
        
        self.collectionView.backgroundView = setupGradientLayer()
        self.collectionView.register(DevicesCollectionViewCell.self, forCellWithReuseIdentifier: DevicesCollectionCellIDs.device.rawValue)
        self.collectionView.register(DevicesCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DevicesCollectionCellIDs.header.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let device = self.viewModel.output.devices.value[indexPath.section]
        if device.CO != nil {
            return .init(width: self.view.frame.width, height: 220)
        } else {
            return .init(width: self.view.frame.width, height: 170)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DevicesCollectionCellIDs.device.rawValue, for: indexPath) as! DevicesCollectionViewCell
        let device = self.viewModel.output.devices.value[indexPath.section]
        cell.temperature = device.temperature
        cell.humidity = device.humidity
        cell.pressure = device.pressure
        cell.pm10 = device.pm10
        cell.pm100 = device.pm100
        cell.pm25 = device.pm25
        cell.CO = device.CO
        cell.hideProgressBar(hide: device.CO == nil)
        
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DevicesCollectionCellIDs.header.rawValue, for: indexPath) as! DevicesCollectionViewHeader
        let device = self.viewModel.output.devices.value[indexPath.section]
        header.device = device
        return header
    }
    
    func setupGradientLayer() -> UIView {
        let viewBG = UIView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 76.0/255.0, green: 130.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 85.0/255.0, green: 159.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.locations = [0, 1.5]
        gradientLayer.frame = viewBG.bounds
        viewBG.layer.addSublayer(gradientLayer)
        return viewBG
    }
    
}
