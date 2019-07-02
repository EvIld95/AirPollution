//
//  AppService
//  Sapiens
//
//  Created by Paweł Szudrowicz on 11/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya

enum AppService {
    case addTracking(token: String, serial: String)
    case addDevice(token: String, serial: String, email: String, latitude: Double, longitude: Double)
    case addSnapshot(token: String, serial: String, trackingId: Int, temperature: Double, pressure: Double, humidity: Double, pm10: Int, pm25: Int, pm100: Int, CO: Double, latitude: Double, longitude: Double)
    case getAllDevices(token: String)
    case getAllTrackingSnapshots(token: String)
}

extension AppService: TargetType {
    var baseURL: URL { return URL(string: "http://40.114.142.212:8080/v1")! }
    var path: String {
        switch self {
        case .addTracking:
            return "/addTracking"
        case .addDevice:
            return "/addDevice"
        case .addSnapshot:
            return "/addSnapshot"
        case .getAllDevices:
            return "/getDevices"
        case .getAllTrackingSnapshots:
            return "/getTrackingSnapshots"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addTracking:
            return .post
        case .addDevice:
            return .post
        case .addSnapshot:
            return .post
        case .getAllDevices:
            return .post
        case .getAllTrackingSnapshots:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .addTracking(let token, let serial):
            return .requestParameters(parameters: ["token": token, "serial": serial], encoding: JSONEncoding.default)
        case .addDevice(let token, let serial, let email, let latitude, let longitude):
            return .requestParameters(parameters: ["token": token, "serial": serial, "email": email, "latitude": latitude, "longitude": longitude], encoding: JSONEncoding.default)
        case .addSnapshot(let token, let serial, let trackingId, let temperature, let pressure, let humidity, let pm10, let pm25, let pm100, let CO, let latitude, let longitude):
            return .requestParameters(parameters: ["token": token, "serial": serial, "trackingId": trackingId, "temperature": temperature, "pressure": pressure, "humidity": humidity, "pm10": pm10, "pm25": pm25, "pm100": pm100, "CO": CO, "latitude": latitude, "longitude": longitude], encoding: JSONEncoding.default)
        case .getAllDevices(let token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case .getAllTrackingSnapshots(let token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .addTracking:
            return "Tracking".utf8Encoded
        case .addDevice:
            return "Test".utf8Encoded
        case .addSnapshot:
            return "ASD".utf8Encoded
        case .getAllDevices:
            return "GETDEVICES".utf8Encoded
        case .getAllTrackingSnapshots:
            return "Snaps".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
