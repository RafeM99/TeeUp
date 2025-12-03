//
//  CaddyViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 01/12/2025.
//

import Foundation
import SwiftUI

@Observable
class CaddyViewModel {
    var distance: Double?
    var lie: Lies = .fairway
    var lieConstant: Double = 1.0
    
    func getRecommendedClub(_ bag: Bag, _ clubToHit: Binding<String>, _ showingAlert: Binding<Bool>) {
        if lie == .fairway {
            lieConstant = 1.0
        } else if lie == .rough {
            lieConstant = 1.1
        } else if lie == .heavyRough {
            lieConstant = 1.25
        } else if lie == .greensideBunker {
            lieConstant = 1.67
        } else if lie == .fairwayBunker {
            lieConstant = 1.15
        }
        
        guard var distanceToHole = distance, distanceToHole > 0.0 else {
            clubToHit.wrappedValue = "Enter a valid distance"
            return
        }
        
        distanceToHole = distanceToHole * lieConstant
        
        // bag.clubs is sorted descending by distance
        if let club = bag.clubs.last(where: { $0.distance >= distanceToHole }) {
            // This yields the smallest club that still reaches the target.
            clubToHit.wrappedValue = club.type.rawValue
        } else if let longest = bag.clubs.first {
            // If no club reaches the target, pick the longest.
            clubToHit.wrappedValue = longest.type.rawValue
        } else {
            // No clubs in the bag
            clubToHit.wrappedValue = "No clubs in bag"
        }
        
        showingAlert.wrappedValue = true
    }
    
    enum Lies: String, CaseIterable, Identifiable {
        case fairway = "Fairway"
        case rough = "Rough"
        case heavyRough = "Heavy Rough"
        case greensideBunker = "Greenside Bunker"
        case fairwayBunker = "Fairway Bunker"
        
        var id: Self { self }
    }
}
