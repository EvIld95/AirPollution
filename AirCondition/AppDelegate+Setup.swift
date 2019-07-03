//
//  AppDelegate+Setup.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 11/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Swinject

extension AppDelegate {
    internal func setupDependencies() {
        
        //otherDependencies
        container.register(AppManager.self) { _ in
            return AppManager()
        }.inObjectScope(.container)
        
        //viewModels
        container.register(RegistrationViewModel.self) { _ in
            return RegistrationViewModel()
        }
        
        container.register(DetailSnapshotViewModel.self) { _ in
            return DetailSnapshotViewModel()
        }
        
        container.register(TrackingHistoryViewModel.self) { r in
            let tvm = TrackingHistoryViewModel()
            tvm.appManager = r.resolve(AppManager.self)
            return tvm
        }
        
        container.register(MapViewModel.self) { (r) in
            let mv = MapViewModel()
            mv.appManager = r.resolve(AppManager.self)
            return mv
        }.inObjectScope(.container)

    
        
        
        //viewControllers
        container.register(RegistrationViewController.self) { r in
            let regVC = RegistrationViewController()
            regVC.viewModel = r.resolve(RegistrationViewModel.self)
            regVC.appManager = r.resolve(AppManager.self)
            return regVC
        }
        
        container.register(MapViewController.self) { r in
            let mainVC = MapViewController()
            mainVC.viewModel = r.resolve(MapViewModel.self)
            mainVC.appManager = r.resolve(AppManager.self)
            return mainVC
        }
        
        container.register(MainTabBarController.self) { r in
            let tabVC = MainTabBarController()
            return tabVC
        }
        
        container.register(DevicesCollectionViewController.self) { (r) in
            let deviceVC = DevicesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            deviceVC.viewModel = r.resolve(MapViewModel.self)
            
            return deviceVC
        }
       
        container.register(TrackingSnapshotsTableViewController.self) { (r) in
            let snapshotTVC = TrackingSnapshotsTableViewController(style: .plain)
            snapshotTVC.viewModel = r.resolve(TrackingHistoryViewModel.self)
            return snapshotTVC
        }
        
        container.register(DetailSnapshotTrackingViewController.self) { r in
            let detailVC = DetailSnapshotTrackingViewController()
            detailVC.viewModel = r.resolve(DetailSnapshotViewModel.self)
            return detailVC
        }
        
    }
}
