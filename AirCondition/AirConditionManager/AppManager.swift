//
//  SapiensManager.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 11/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import Moya
import Moya_SwiftyJSONMapper
import SwiftyJSON
import Firebase

class AppManager {
    func basic() {
        let provider = MoyaProvider<AppService>()
        
        provider.request(.basic) { result in
            switch result {
            case let .success(response):
                print(String(bytes: response.data, encoding: .utf8) ?? "Success")
                
            case .failure:
                print("ERROR")
            }
        }
    }
    
    func addNewDevice(serial: String, completion: @escaping () -> ()) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        let email = Auth.auth().currentUser!.email
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            provider.request(.addDevice(token: idToken!, serial: serial, email: email!)) { result in
                switch result {
                case .success:
                    completion()
                    
                case .failure:
                    print("ERROR")
                }
            }
        }
    }
    
    
    func testAirly(latitude: Double, longitude: Double) {
        let provider = MoyaProvider<AirlyService>(plugins: [CompleteUrlLoggerPlugin()])
        
        provider.request(.nearestInstallations(latitude: latitude, longitude: longitude, distance: 10.0)) { result in
            switch result {
            case let .success(response):
                let data = try? response.map(to: AirlyNearestDevice.self)
            case .failure:
                print("ERROR")
            }
        }
    }
}
