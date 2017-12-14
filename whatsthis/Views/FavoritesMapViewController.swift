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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for photo in self.photos! {
            let annotation: MKPointAnnotation = MKPointAnnotation()
            
            //Checks whether photo has lat and lon
            if(photo.lat != 200 || photo.lon != 200){
                annotation.coordinate.latitude = photo.lat
                annotation.coordinate.longitude = photo.lon
                annotation.title = photo.text
                annotations.append(annotation)
                // Creates and adds MKPointAnnotations to the Map
                mapView.addAnnotation(annotation)
            }
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - Current Location
    let locationManager = CLLocationManager()
    
    //Checks location Authorization for showing user location in Map
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

