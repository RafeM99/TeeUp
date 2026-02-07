//
//  RoundSummaryViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 01/12/2025.
//

import Foundation
import SwiftUI

@Observable
class RoundSummaryViewModel {
    // gets number over/under par (e.g. +5, E, -5)
    func getParComparison(userTotal: Int, teeTotal: Int) -> String {
        let parDifference = userTotal - teeTotal
        
        if parDifference == 0 {
            return "E"
        } else if parDifference > 0 {
            return "+" + String(parDifference)
        } else {
            return String(parDifference)
        }
    }
    
    // gets colour to display par comparison
    func parColour(userTotal: Int, teeTotal: Int) -> Color {
        let diff = userTotal - teeTotal
        if diff == 0 {
            return .gray
        } else if diff > 0 {
            return .blue
        } else {
            return .red
        }
    }
}
