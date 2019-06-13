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
    case basic
    case addDevice(token: String, serial: String, email: String)
    case addSnapshot(token: String, serial: String, temperature: Double, pressure: Double, humidity: Double, pm10: Int, pm25: Int, pm100: Int, CO: Double, latitude: Double, longitude: Double)
}

extension AppService: TargetType {
    var baseURL: URL { return URL(string: "http://40.114.142.212:8080/v1")! }
    var path: String {
        switch self {
        case .basic:
            return "/testAddress"
        case .addDevice:
            return "/addDevice"
        case .addSnapshot:
            return "/addSnapshot"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .basic:
            return .get
        case .addDevice:
            return .post
        case .addSnapshot:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .basic:
            return .requestPlain
        case .addDevice(let token, let serial, let email):
            return .requestParameters(parameters: ["token": token, "serial": serial, "email": email], encoding: JSONEncoding.default)
        case .addSnapshot(let token, let serial, let temperature, let pressure, let humidity, let pm10, let pm25, let pm100, let CO, let latitude, let longitude):
            return .requestParameters(parameters: ["token": token, "serial": serial, "temperature": temperature, "pressure": pressure, "humidity": humidity, "pm10": pm10, "pm25": pm25, "pm100": pm100, "CO": CO, "latitude": latitude, "longitude": longitude], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .basic:
            return "{\"id\": \"http://52.236.165.15/hls/test.m3u8\"}".utf8Encoded
        case .addDevice:
            return "Test".utf8Encoded
        case .addSnapshot:
            return "ASD".utf8Encoded
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
