//
//  RecommendedNearbyCourse.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 16/10/2025.
//

import Foundation

struct RecommendedNearbyCourse: Identifiable{
    let id = UUID()
    let name: String
    let distanceKm: Double
    let coordinates: (Double, Double)
}
