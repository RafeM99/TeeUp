//
//  Location.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Location: Sendable, Decodable {
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    
    var displayText: String {
        let components = [address, city, state, country].compactMap { $0 }
        
        if !components.isEmpty {
            return components.joined(separator: "\n")
        }
        
        // Fallback to coordinates if available
        if let lat = latitude, let lon = longitude {
            return "Coordinates: \(String(format: "%.4f", lat)), \(String(format: "%.4f", lon))"
        }
        
        return "Location information not available"
    }
}
