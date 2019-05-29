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
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController, container: Container) {
        self.childCoordinators = [AppChildCoordinator: Coordinator]()
        self.navigationController = presenter
        self.navigationController.title = "Air"
        self.container = container
    }
    
    func start() {
        self.mainTabBarController = container.resolve(MainTabBarController.self)!
        self.setupViewControllers()
        self.navigationController.pushViewController(mainTabBarController, animated: true)
        
    }
    
    func setupViewControllers() {
        let mapViewController = self.container.resolve(MapViewController.self)
        let mapNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: mapViewController!)
        
        let deviceCollectionViewController = self.container.resolve(DevicesCollectionViewController.self)
        let deviceViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: deviceCollectionViewController!)
        deviceViewController.isNavigationBarHidden = true

        self.mainTabBarController.tabBar.tintColor = .black
        self.mainTabBarController.viewControllers = [mapNavController, deviceViewController]
        
        for item in  self.mainTabBarController.tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
    
}

