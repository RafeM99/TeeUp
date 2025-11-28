//
//  RoundViewModel.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 28/11/2025.
//

import Foundation

@Observable
class RoundViewModel {
    var holeNumber: Int = 1
    var showingAlert: Bool = false
    var pendingScore: Int?
    var totalScore: Int = 0
    var showScorecard: Bool = false
    var showCaddy: Bool = false
    var showingCaddyAlert: Bool = false
    var recommendedClub: String = ""
}
