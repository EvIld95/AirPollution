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
import RxCocoa
import MapKit

enum PolylineDisplayMode {
    case normalized
    case standard
}

class DetailSnapshotTrackingViewController: UIViewController {
    var viewModel: DetailSnapshotViewModel!
    lazy var mapView: MKMapView! = {
        let mv = MKMapView()
        mv.showsUserLocation = false
        mv.delegate = self
        return mv
    }()
    
    let displayModeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Normalized", "3 colors"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override func viewDidLoad() {
        setupLayout()
        setupRx()
        for data in self.viewModel.output.selectedSnapshots.value {
            let annotation = AnnotationPointSnapshot(data: data)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func setupRx() {
        displayModeSegmentedControl.rx.selectedSegmentIndex.distinctUntilChanged().asObservable().subscribe(onNext: { value in
            self.loadMap(mode: value == 0 ? .normalized : .standard)
        })
    }
    
    private func setupLayout() {
        self.view.addSubview(mapView)
        self.view.addSubview(displayModeSegmentedControl)
        mapView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        displayModeSegmentedControl.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor , padding: .init(top: 10, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 30))
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
        
        let locations = self.viewModel.output.selectedSnapshots.value.map { (sensor) -> CLLocationCoordinate2D in
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
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineCap = .round
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 5
        
        return renderer
    }
    
    
    func polyline() -> MKPolyline {
        let locations = self.viewModel.output.selectedSnapshots.value.map { (sensor) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!)
        }
        return MKPolyline(coordinates: locations, count: locations.count)
    }
    
    func loadMap(mode: PolylineDisplayMode) {
        if self.viewModel.output.selectedSnapshots.value.count > 0 {
            mapView.region = mapRegion()
            let colorSegments = MulticolorPolylineSegment.colorSegments(forData: self.viewModel.output.selectedSnapshots.value, mode: mode)
            mapView.addOverlays(colorSegments)
        } else {
            print("ERROR with map")
        }
    }
}
