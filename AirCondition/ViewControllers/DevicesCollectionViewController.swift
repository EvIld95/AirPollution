//
//  DevicesCollectionViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 28/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum DevicesCollectionCellIDs: String {
    case device
    case header
}

class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: MapViewModel!
    let disposeBag = DisposeBag()
    
    var filteredData = Variable<[DeviceModel]>([])
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter city"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    lazy var tapGesure: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        
        return tap
    }()
    
    @objc func tapHandler() {
        self.searchBar.endEditing(true)
        self.collectionView.resignFirstResponder()
        self.collectionView.endEditing(true)
   
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredData.value.count
    }
    
    
    override func viewDidLoad() {
        if let cvLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            cvLayout.scrollDirection = .vertical
        }
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor, padding: .init(top: 4, left: 40, bottom: 4, right: 40))
        
        
        self.collectionView.addGestureRecognizer(tapGesure)
        self.collectionView.keyboardDismissMode = .onDrag
        self.title = "Device"
        self.setupRx()
        self.collectionView.backgroundView = UIView.getGradientLayer(view: self.collectionView)
        self.collectionView.register(DevicesCollectionViewCell.self, forCellWithReuseIdentifier: DevicesCollectionCellIDs.device.rawValue)
        self.collectionView.register(DevicesCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DevicesCollectionCellIDs.header.rawValue)
    }
    
    func setupRx() {
        self.viewModel.output.devices.asObservable().subscribe(onNext: { devices in
            self.filteredData.value = devices
        }).disposed(by: disposeBag)
        self.filteredData.asObservable().subscribe(onNext: { _ in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let device = self.filteredData.value[indexPath.section]
        if device.CO.value != nil {
            return .init(width: self.view.frame.width, height: 220)
        } else {
            return .init(width: self.view.frame.width, height: 170)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DevicesCollectionCellIDs.device.rawValue, for: indexPath) as! DevicesCollectionViewCell
        let device = self.filteredData.value[indexPath.section]

        cell.hideProgressBar(hide: device.CO.value == nil)
        cell.device = device
        
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
        let device = self.filteredData.value[indexPath.section]
        header.device = device
        header.delegate = self
        return header
    }
    
}

extension DevicesCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
             self.filteredData.value = self.viewModel.output.devices.value.filter { (device) -> Bool in
                return device.addressVariable.value.lowercased().contains(searchText.lowercased())
             }
        } else {
            self.filteredData.value = self.viewModel.output.devices.value
        }
    }
}

extension DevicesCollectionViewController: DevicesSelectableToTrackDelegate {
    func didSelectDeviceToTrack(device: DeviceModel) {
        viewModel.startTracking(device: device)
    }
    
    func stopTrackDevice(device: DeviceModel) {
        viewModel.stopTracking(device: device)
    }
}
