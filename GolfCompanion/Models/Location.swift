//
//  Location.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Location: Sendable, Decodable {
    let address: String
    let city: String
    let state: String
    let country: String
    let latitude: Double
    let longitude: Double
}
