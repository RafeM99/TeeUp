//
//  StateController.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 13/09/2025.
//

import Foundation

@Observable
class StateController {
    static let shared = StateController()
    
    private init() {}
    
    var coordinates: (Double, Double) = (0.0, 0.0)
}
