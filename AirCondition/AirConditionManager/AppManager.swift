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
import FirebaseDatabase
import CoreLocation

class AppManager {
    func addNewDevice(serial: String, email: String, longitude: Double, latitude: Double , completion: @escaping (DeviceModel) -> ()) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        let email = Auth.auth().currentUser!.email
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            provider.request(.addDevice(token: idToken!, serial: serial, email: email!, latitude: latitude, longitude: longitude)) { result in
                switch result {
                case .success:
                    guard let deviceModel = DeviceModel(device: Device(email: email, serial: serial, latitude: latitude, longitude: longitude)) else { return }
                    completion(deviceModel)
                    
                case .failure:
                    print("ERROR")
                }
            }
        }
    }
    
    func getAllDevices(completion: @escaping ([Device]) -> ()) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            guard let idToken = idToken else { return }
            
            provider.request(.getAllDevices(token: idToken), completion: { (result) in
                switch result {
                case let .success(response):
                    guard let data = try? response.map(to: MultipleDevicesModel.self) else { return }
                    completion(data.array)
                case .failure:
                    print("ERROR")
                }
            })
        }
    }
    
    func checkIfDeviceExists(serial: String, completion: @escaping (Bool) -> ()) {
        let ref = Database.database().reference().child("airDevice")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let keys = dict.keys
                completion(keys.contains(serial))
            }
        }
    }
    
    func addTracking(serial: String, completion: @escaping (TrackingModel) -> ()) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                guard let id = idToken else { return }
                provider.request(.addTracking(token: id, serial: serial), completion: { (result) in
                    switch result {
                    case let .success(response):
                        if response.statusCode == 404 {
                            print("Error")
                        } else {
                             let data = try! response.map(to: TrackingModel.self) //else { return }
                            completion(data)
                        }
                        
                    case .failure:
                        print("ERROR")
                    }
                })
        })
    }
    
    func getAllTrackingSnapshots(completion: @escaping ([Int: [SensorData]]) -> ()) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            guard let idToken = idToken else { return }
            
            provider.request(.getAllTrackingSnapshots(token: idToken), completion: { (result) in
                switch result {
                case let .success(response):
                    guard let data = try? response.map(to: TrackingSnapshotModel.self) else { return }
                    completion(data.dict)
                case .failure:
                    print("ERROR")
                }
            })
        }
    }
    
    func addSnapshot(serial: String, trackingId: Int, temperature: Double, pressure: Double, humidity: Double, pm10: Int, pm100: Int, pm25: Int, CO: Double, location: CLLocation, completion: (() -> ())?) {
        let provider = MoyaProvider<AppService>()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                guard let id = idToken else { return }
            provider.request(.addSnapshot(token: id, serial: serial, trackingId: trackingId, temperature: temperature, pressure: pressure, humidity: humidity, pm10: pm10, pm25: pm25, pm100: pm100, CO: CO, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), completion: { (result) in
                    switch result {
                    case .success:
                        completion?()
                    
                    case .failure:
                        print("ERROR")
                    }
                })
        })
    }
    
    
    func nearestInstallation(latitude: Double, longitude: Double, completionHandler: @escaping ([NearestDevice]) -> ()) {
        let provider = MoyaProvider<AirlyService>(plugins: [CompleteUrlLoggerPlugin()])
        
        provider.request(.nearestInstallations(latitude: latitude, longitude: longitude, distance: 50.0)) { result in
            switch result {
            case let .success(response):
                guard let data = try? response.map(to: AirlyNearestDevice.self) else { return }
                completionHandler(data.array)
            case .failure:
                print("ERROR")
            }
        }
    }
    
    func measurement(device: NearestDevice, completionHandler: @escaping (AirlyDeviceSensor) -> ()) {
        let provider = MoyaProvider<AirlyService>(plugins: [CompleteUrlLoggerPlugin()])
        
        provider.request(.measurement(installationId: device.id!)) { result in
            switch result {
            case let .success(response):
                guard let data = try? response.map(to: AirlyDeviceSensor.self) else { return }
                data.id = device.id
                data.deviceAirly = device
                completionHandler(data)
            case .failure:
                print("ERROR")
            }
        }
    }

}
