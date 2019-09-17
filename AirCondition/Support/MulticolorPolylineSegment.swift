//
//  MulticolorPolylineSegment.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 02/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MulticolorPolylineSegment: MKPolyline {
    var color: UIColor?
    
    private class func minMax(forData sensorPM100s: [Int]) ->
        (minSpeed: Int, maxSpeed: Int) {
            let minVal = sensorPM100s.min()
            let maxVal = sensorPM100s.max()
            return (minVal!, maxVal!)
    }
    
    class func colorSegments(forData data: [SensorData], mode: PolylineDisplayMode) -> [MulticolorPolylineSegment] {
        var colorSegments = [MulticolorPolylineSegment]()
        
        let pm100s = data.map { (sensor) -> Int in
            return sensor.pm100 ?? 0
        }
        
        let pm25s = data.map { (sensor) -> Int in
            return sensor.pm25 ?? 0
        }
        
        let COs = data.map { (sensor) -> Int in
            return sensor.CO ?? 0
        }
        
        let locations = data.map { (sensor) -> CLLocation in
            return CLLocation(latitude: sensor.latitude!, longitude: sensor.longitude!)
        }
        
        let (minPM, maxPM) = minMax(forData: pm100s)
        let (minCO, maxCO) = minMax(forData: COs)
        
        for i in 1..<locations.count {
            let l1 = locations[i-1]
            let l2 = locations[i]
            
            var coords = [CLLocationCoordinate2D]()
            
            coords.append(l1.coordinate)
            coords.append(l2.coordinate)
            
            let pm100 = pm100s[i-1]
            let pm25 = pm25s[i-1]
            let CO = COs[i-1]
            
            var color: UIColor!
            if mode == .normalized {
                var ratio = 0.0
                if Double(maxPM - minPM) != 0 {
                    ratio = Double(pm100 - minPM) / Double(maxPM - minPM)
                }
                color = UIColor(hue: CGFloat(0.33 - ((ratio) * 0.33)), saturation: 1, brightness: 1, alpha: 1)
            } else if mode == .standard {
                if pm25 < 25 && pm100 < 50 {
                    color = UIColor.green
                } else if pm100 < 300 {
                    color = UIColor.orange
                } else {
                    color = UIColor.red
                }
            } else if mode == .CO {
                var ratio = 0.0
                if Double(maxCO - minCO) != 0 {
                    ratio = Double(CO - minCO) / Double(maxCO - minCO)
                }
                color = UIColor(hue: CGFloat(0.33 - ((ratio) * 0.33)), saturation: 1, brightness: 1, alpha: 1)
            }
            
            let segment = MulticolorPolylineSegment(coordinates: &coords, count: coords.count)
            segment.color = color
            colorSegments.append(segment)
        }
        
        return colorSegments
    }
}

