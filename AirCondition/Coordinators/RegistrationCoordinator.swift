//
//  RegistrationCoordinator.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 10/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift

class RegistrationCoordinator: Coordinator {
    var container: Container
    var childCoordinators: [AppChildCoordinator: Coordinator]
    var navigationController: UINavigationController
    var registrationViewController: RegistrationViewController!
    var parentCoordiantor: Coordinator!
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController, container: Container, parent: Coordinator) {
        self.childCoordinators = [AppChildCoordinator: Coordinator]()
        self.navigationController = presenter
        self.navigationController.isNavigationBarHidden = true
        self.container = container
        self.parentCoordiantor = parent
    }
    
    func start() {
        self.registrationViewController = container.resolve(RegistrationViewController.self)!
        
        Observable.merge(self.registrationViewController.viewModel.actionLogin.elements, self.registrationViewController.viewModel.actionRegister.elements).take(1).subscribe(onNext: {
            self.launchMainViewController()
        }).disposed(by: disposeBag)
        
        self.navigationController.present(self.registrationViewController, animated: true, completion: nil)
        //navigationController.pushViewController(self.registrationViewController, animated: true)
    }
    
    func launchMainViewController() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.parentCoordiantor.childCoordinators.removeValue(forKey: .register)
        self.parentCoordiantor.start()
    }
}
