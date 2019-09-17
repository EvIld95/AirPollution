//
//  AirlyService.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 05/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import Moya

class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}

enum AirlyService {
    case basic
    case nearestInstallations(latitude: Double, longitude: Double, distance: Double)
    case measurement(installationId: Int)
}

extension AirlyService: TargetType {
    var baseURL: URL { return URL(string: "https://airapi.airly.eu/v2")! }
    var path: String {
        switch self {
        case .basic:
            return "/testAddress"
        case .nearestInstallations:
            return "/installations/nearest"
        case .measurement:
            return "/measurements/installation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .basic:
            return .get
        case .nearestInstallations:
            return .get
        case .measurement:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .basic:
            return .requestPlain
        case .nearestInstallations(let lat, let lon, let distance):
            return .requestParameters(parameters: ["lat": lat, "lng": lon, "maxDistanceKM": distance, "maxResults" : 5], encoding: URLEncoding.default)
        case .measurement(let installationId):
            return .requestParameters(parameters: ["installationId": installationId], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .basic:
            return "ooo".utf8Encoded
        case .nearestInstallations:
            return "[{\"id\": 1, \"address\": {\"street\": \"Dominikanska\", \"city\": \"Poznan\"}, \"location\": { \"latitude\": 50.5, \"longitude\": 16.6}}]".utf8Encoded
        case .measurement:
            return "{\"current\": {\"values\": [{}]}".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json", "apikey" : "alzZ40TC5ZLvO1lzw8o0BWdmdLBeDTF6"]
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
