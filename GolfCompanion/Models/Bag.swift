//
//  Bag.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 08/07/2025.
//

import Foundation

@Observable
class Bag {
    var clubs: [Club]
    
    static var examples: [Club] {
        return [
            Club(type: .driver, brand: "Titleist", isLeftHanded: false, distance: 250),
            Club(type: .threeWood, brand: "Callaway", isLeftHanded: false, distance: 230),
            Club(type: .fiveWood, brand: "Ping", isLeftHanded: false, distance: 220),
            Club(type: .fiveIron, brand: "TaylorMade", isLeftHanded: false, distance: 200),
            Club(type: .sixIron, brand: "Cobra", isLeftHanded: false, distance: 190),
            Club(type: .sevenIron, brand: "Mizuno", isLeftHanded: false, distance: 180),
            Club(type: .eightIron, brand: "Nike", isLeftHanded: false, distance: 165),
            Club(type: .nineIron, brand: "Wilson", isLeftHanded: false, distance: 150),
            Club(type: .pitchingWedge, brand: "Titleist", isLeftHanded: false, distance: 135),
            Club(type: .sandWedge, brand: "Cleveland", isLeftHanded: false, distance: 85),
            Club(type: .putter, brand: "Odyssey", isLeftHanded: true, distance: 50)
        ]
    }
    
    init(clubs: [Club]) {
        self.clubs = clubs
    }
}
