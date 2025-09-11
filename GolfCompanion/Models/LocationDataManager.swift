//
//  LocationDataManager.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 10/09/2025.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    var coordinates: (Double, Double) = (0.0, 0.0)
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func updateLocation() {
        manager.requestLocation()
    }
    
//    Gets coordinates after location updates and puts them into a tuple
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            coordinates = (Double(lastLocation.coordinate.latitude), Double(lastLocation.coordinate.longitude))
        }
    }
}
