//
//  MainTabCoordinator.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 14/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift
import Firebase


class MainTabBarCoordinator: Coordinator {
    var container: Container
    var childCoordinators: [AppChildCoordinator: Coordinator]
    var navigationController: UINavigationController
    var mainTabBarController: MainTabBarController!
    var parentCoordiantor: Coordinator!
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController, container: Container, parent: Coordinator) {
        self.childCoordinators = [AppChildCoordinator: Coordinator]()
        self.navigationController = presenter
        self.container = container
        self.parentCoordiantor = parent
    }
    
    func start() {
        self.mainTabBarController = container.resolve(MainTabBarController.self)!
        self.setupViewControllers()
        self.navigationController.pushViewController(mainTabBarController, animated: true)
        self.navigationController.isNavigationBarHidden = true
    }
    
    func setupViewControllers() {
        let mapViewController = self.container.resolve(MapViewController.self)
        mapViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logout))
        let mapNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: mapViewController!)
        
        let deviceCollectionViewController = self.container.resolve(DevicesCollectionViewController.self)
        let deviceViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: deviceCollectionViewController!)
        
        let snapshotsTableViewController = self.container.resolve(TrackingSnapshotsTableViewController.self)
        let snapshotsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: snapshotsTableViewController!)
        
        

        self.mainTabBarController.tabBar.tintColor = .black
        self.mainTabBarController.viewControllers = [mapNavController, deviceViewController, snapshotsNavController]
      
        
        
        for item in  self.mainTabBarController.tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        snapshotsTableViewController?.viewModel.output.selectedSnapshots.asObservable().skip(1).subscribe(onNext: { _ in
            let snapshotsDetailViewController = self.container.resolve(DetailSnapshotTrackingViewController.self)
            snapshotsDetailViewController?.viewModel.output.selectedSnapshots.value = snapshotsTableViewController!.viewModel.output.selectedSnapshots.value
            snapshotsNavController.pushViewController(snapshotsDetailViewController!, animated: true)
        }).disposed(by: disposeBag)
        
        mapViewController?.viewModel.input.showDeviceHistoryWithSerial.asObservable().filter({ (value) -> Bool in
            return value != ""
        }).observeOn(MainScheduler.instance).subscribe(onNext: { serial in
            let dhViewController = self.container.resolve(DeviceHistoryViewController.self)!
            dhViewController.viewModel.input.serial.value = serial
            mapNavController.show(dhViewController, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    
    @objc func logout() {
        guard let _ = try? Auth.auth().signOut() else { return }
        self.parentCoordiantor.start()
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
}

