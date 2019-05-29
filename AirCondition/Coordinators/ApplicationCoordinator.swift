//
//  ApplicationCoordinator.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 10/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import Firebase


enum AppChildCoordinator {
    case register
    case main
}

class ApplicationCoordinator: Coordinator {
    var container: Container
    var childCoordinators: [AppChildCoordinator: Coordinator]
    var navigationController: UINavigationController
    let window: UIWindow
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        self.childCoordinators = [AppChildCoordinator: Coordinator]()
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        guard let _ = try? Auth.auth().signOut() else { return }
        
        if Auth.auth().currentUser == nil {
            //presentedModally
            DispatchQueue.main.async {
                let registrationCoordinator = RegistrationCoordinator(presenter: self.navigationController, container: self.container, parent: self)
                self.childCoordinators[.register] = registrationCoordinator
                registrationCoordinator.start()
            }
        }
        let mainCoordinator = MainTabBarCoordinator(presenter: self.navigationController, container: self.container)
        self.childCoordinators[.main] = mainCoordinator
        mainCoordinator.start()
        
    }
}
