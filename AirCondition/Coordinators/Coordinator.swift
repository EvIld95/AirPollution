//
//  Coordinator.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 10/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import Swinject


protocol Coordinator: AnyObject {
    var container: Container { get }
    var childCoordinators: [AppChildCoordinator: Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
