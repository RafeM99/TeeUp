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
    private var callback: ((_ coordinates: (Double, Double)) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
//    requests the location asynchronously and asigns the result to callback
    func requestLocation(completion: @escaping (_ coordinates: (Double, Double)) -> Void) {
        callback = completion
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        callback?((locations.first?.coordinate.latitude ?? -1.0, locations.first?.coordinate.longitude ?? -1.0))
    }
    
//    placeholder in case of error finding location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        callback?((0.0, 0.0))
    }
}
