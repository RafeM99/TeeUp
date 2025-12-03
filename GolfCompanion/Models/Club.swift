//
//  Club.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 08/07/2025.
//

import Foundation

enum ClubType: String, CaseIterable, Decodable, Encodable {
    case driver = "Driver"
    case threeWood = "3 Wood"
    case fiveWood = "5 Wood"
    case sevenWood = "7 Wood"
    case threeHybrid = "3 Hybrid"
    case fourHybrid = "4 Hybrid"
    case fiveHybrid = "5 Hybrid"
    case sixHybrid = "6 Hybrid"
    case sevenHybrid = "7 Hybrid"
    case threeIron = "3 Iron"
    case fourIron = "4 Iron"
    case fiveIron = "5 Iron"
    case sixIron = "6 Iron"
    case sevenIron = "7 Iron"
    case eightIron = "8 Iron"
    case nineIron = "9 Iron"
    case tenIron = "10 Iron"
    case pitchingWedge = "Pitching Wedge"
    case sandWedge = "Sand Wedge"
    case fiftyTwoDegree = "52° Wedge"
    case fiftySixDegree = "56° Wedge"
    case sixtyDegree = "60° Wedge"
    case putter = "Putter"
}

@Observable
class Club: Identifiable, Encodable, Decodable {
    var id: UUID
    let type: ClubType
    var brand: String
    var isLeftHanded: Bool
    var distance: Double
    
    init(type: ClubType, brand: String, isLeftHanded: Bool, distance: Double) {
        self.id = UUID()
        self.type = type
        self.brand = brand
        self.isLeftHanded = isLeftHanded
        self.distance = distance
    }
}
