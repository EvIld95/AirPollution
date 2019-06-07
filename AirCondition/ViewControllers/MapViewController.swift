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
    var appManager: AppManager!
    
    lazy var mapView: MKMapView! = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        mv.delegate = self
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        self.setupLayout()
        self.setupLocationManager()
        self.setupRx()
     }
    
    private func setupLayout() {
        self.view.addSubview(mapView)
        mapView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
    }
    
    private func setupRx() {
        self.viewModel.output.deviceStream.flatMap { (device) in
            return device.address.map({ (address) -> AnnotationPointDevice in
                let annotation = AnnotationPointDevice(device: device)
                annotation.title = address
                annotation.coordinate = CLLocationCoordinate2D(latitude: device.latitude.value, longitude: device.longitude.value)
                return annotation
            })
            }.filter({ (annotation) -> Bool in
                for oldAnnotation in self.mapView.annotations {
                    guard let oldAnnotationDevice = oldAnnotation as? AnnotationPointDevice else { continue }
                    if oldAnnotationDevice.device === annotation.device {
                        return false
                    }
                }
                return true
            }).subscribe(onNext: { annotation in
            self.mapView.addAnnotation(annotation)
        }).disposed(by: disposeBag)
        
        
        self.viewModel.output.deviceStream.flatMap { (device) in
            return device.airQualityChanged
            }.flatMap { (device) in
                Observable<AnnotationPointDevice>.create({ (obs) -> Disposable in
                    let annotations = self.mapView.annotations.filter({ (annotation) -> Bool in
                        guard let annotationDevice = annotation as? AnnotationPointDevice else { return false }
                        return annotationDevice.device === device
                    })
                    if annotations.count > 0 {
                        obs.onNext(annotations.first! as! AnnotationPointDevice)
                    }
                    return Disposables.create()
                })
        }.subscribe(onNext: { annotation in
            
                let annotationView = self.mapView.view(for: annotation)
                let indicatorView = AirStatusIndicatorView(device: annotation.device)
                annotationView?.image = indicatorView.getImage()
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
        
        let id = "id"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        let deviceView = DeviceValuesView(device: annotation.device, frame: .init(x: 0, y: 0, width: 300, height: 200))
       
        if annotationView == nil {
            let indicatorView = AirStatusIndicatorView(device: annotation.device)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            guard let annotationView = annotationView else { return nil }
            annotationView.canShowCallout = true
            annotationView.isEnabled = true
            annotationView.image = indicatorView.getImage()
            annotationView.detailCalloutAccessoryView = deviceView
        
        } else {
            annotationView!.annotation = annotation
            annotationView!.detailCalloutAccessoryView = deviceView
        }
        
        return annotationView
    }
    
}
var request = false

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if !request {
            appManager.nearestInstallation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude) { devices in
                for device in devices {
                    self.appManager.measurement(id: device.id!) { sensor in
                        sensor.deviceAirly = device
                        let deviceModel = DeviceModel(deviceAirly: sensor)
                        self.viewModel.addNewDevice(dev: deviceModel)
                    }
                }
            }
            
        }
        request = true

    }
}

