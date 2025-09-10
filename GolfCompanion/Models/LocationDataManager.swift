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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            
        }
    }
}
