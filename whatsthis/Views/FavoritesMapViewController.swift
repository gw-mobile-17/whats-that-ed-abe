//
//  FavoritesMapViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/8/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit
import MapKit

class FavoritesMapViewController: UIViewController {
    // MARK: - Properties
    var annotations: [MKPointAnnotation] = Array()
    var photos: [PhotoModel]?
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for photo in self.photos! {
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate.latitude = photo.lat
            annotation.coordinate.longitude = photo.lon
            annotation.title = photo.text
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
        
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
          mapView.showsUserLocation = true
        } else {
          locationManager.requestWhenInUseAuthorization()
        }
    }
}

