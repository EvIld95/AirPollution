//
//  DetailSnapshotTrackingViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 02/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MapKit


class DetailSnapshotTrackingViewController: UIViewController {
    
    var sensorData: [SensorData]!
    lazy var mapView: MKMapView! = {
        let mv = MKMapView()
        mv.showsUserLocation = false
        mv.delegate = self
        return mv
    }()
    
    override func viewDidLoad() {
        setupLayout()
        for data in sensorData {
            let annotation = AnnotationPointSnapshot(data: data)
            self.mapView.addAnnotation(annotation)
        }
        
        loadMap()
    }
    
    private func setupLayout() {
        self.view.addSubview(mapView)
        mapView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
    }
}


extension DetailSnapshotTrackingViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        guard let annotation = annotation as? AnnotationPointSnapshot else { return nil }
        
        let id = "id"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        print(annotation.data.pm100!)
        let deviceView = DeviceValuesView(frame: .init(x: 0, y: 0, width: 300, height: 200))
        
        deviceView.temperature = annotation.data.temperature!
        deviceView.pressure = annotation.data.pressure!
        deviceView.humidity = annotation.data.humidity!
        deviceView.pm10 = annotation.data.pm10!
        deviceView.pm25 = annotation.data.pm25!
        deviceView.pm100 = annotation.data.pm100!
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            guard let annotationView = annotationView else { return nil }
            annotationView.canShowCallout = true
            annotationView.isEnabled = true
            annotationView.image = #imageLiteral(resourceName: "home_selected")
            annotationView.detailCalloutAccessoryView = deviceView
            
        } else {
            annotationView!.annotation = annotation
            annotationView!.detailCalloutAccessoryView = deviceView
        }
        
        return annotationView
    }
    
    
    func mapRegion() -> MKCoordinateRegion {
        
        let locations = sensorData.map { (sensor) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!)
        }
        
        let initialLoc = locations.first!
        
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for locationRM in locations {
            minLat = min(minLat, locationRM.latitude)
            minLng = min(minLng, locationRM.longitude)
            maxLat = max(maxLat, locationRM.latitude)
            maxLng = max(maxLng, locationRM.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2),span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.2, longitudeDelta: (maxLng - minLng)*1.2))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MulticolorPolylineSegment
        //let polyline = overlay as! MKPolyline
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        //renderer.strokeColor = UIColor.red
        renderer.lineCap = .round
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 5
        
        return renderer
    }
    
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = sensorData.map { (sensor) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!)
        }
        
        
        return MKPolyline(coordinates: locations, count: locations.count)
    }
    
    
    func loadMap() {
        if sensorData.count > 0 {
            mapView.region = mapRegion()
            let colorSegments = MulticolorPolylineSegment.colorSegments(forData: sensorData)
            mapView.addOverlays(colorSegments)
            //mapView.add(polyline())
        } else {
            print("ERROR with map")
        }
    }
}
