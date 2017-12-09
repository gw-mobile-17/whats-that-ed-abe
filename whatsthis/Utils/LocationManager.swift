//
//  LocationManager.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/8/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationManagerDelegate {
    func locationFound(latitude: Double, longitude: Double)
    func locationNotFound(reason: LocationFailureReason)
}

enum LocationFailureReason: String {
    case noPermission = "Location permission not available"
    case timeout = "It took too long to find your location"
    case error = "Error finding location"
}

class LocationManager : NSObject {
    static let sharedInstance = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var delegate: LocationManagerDelegate?
    
    var timer = Timer()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func startTimer() {
        cancelTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (timer) in
            //code that will run 10 seconds later
            self.locationManager.stopUpdatingLocation()
            self.delegate?.locationNotFound(reason: .timeout)
        })
    }
    
    func cancelTimer() {
        timer.invalidate()
    }
    
    func findLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        NSLog("LocationManager: \(status)")

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.locationNotFound(reason: .noPermission)
        case .authorizedWhenInUse:
            startTimer()
            locationManager.requestLocation()
        case .authorizedAlways:
            //do nothing - app can't get to this state
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("LocationManager: Location Updated")
        cancelTimer()
        manager.stopUpdatingLocation()
        let location = locations.first!
        delegate?.locationFound(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NSLog("LocationManager: Auth changed")
        if status == .authorizedWhenInUse {
            startTimer()
            locationManager.requestLocation()
        }
        else {
            delegate?.locationNotFound(reason: .noPermission)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("LocationManager: Request failed")
        cancelTimer()
        print(error.localizedDescription)
        delegate?.locationNotFound(reason: .error)
    }
}
