//
//  MainViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 14/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
    var viewModel: MapViewModel!
    var locationManager = CLLocationManager()
    let disposeBag = DisposeBag()
    lazy var mapView: MKMapView! = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        mv.delegate = self
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupLocationManager()
        self.setupRx()
    }
    
    private func setupLayout() {
        self.view.addSubview(mapView)
        mapView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
    }
    
    private func setupRx() {
        self.viewModel.output.devices.asObservable().subscribe(onNext: { (devices) in
            for device in devices {
                let annotation = AnnotationPointDevice(device: device)
                annotation.title = "Location"
                annotation.coordinate = CLLocationCoordinate2D(latitude: device.latitude, longitude: device.longitude)
               
                self.mapView.addAnnotation(annotation)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        locationManager.distanceFilter = 5.0
        locationManager.requestWhenInUseAuthorization()
    }
    
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        guard let annotation = annotation as? AnnotationPointDevice else { return nil }
        
        
        let id = "item"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if annotationView == nil {
            let indicatorView = AirStatusIndicatorView(device: annotation.device)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            guard let annotationView = annotationView else { return nil }
            annotationView.canShowCallout = true
            annotationView.isEnabled = true
            annotationView.image = indicatorView.getImage()
            
            let label = UILabel(frame: .init(x: 0, y: 0, width: 120, height: 40))
            label.text = "Time"
            annotationView.rightCalloutAccessoryView = label
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      //  mapView.setRegion(region, animated: true)
    }
}