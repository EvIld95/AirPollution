//
//  MainTabBarController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 21/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    let appManager = AppManager()
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addHandler), for: .touchUpInside)
        return button
    }()
    
    @objc func addHandler() {
        appManager.addNewDevice(serial: "123123123") {
            print("DO?ne")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
