//
//  AddClubViewModel.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 26/11/2025.
//

import Foundation

@Observable
class AddClubViewModel {
    var newType: ClubType = .driver
    var newBrand: String = ""
    var newIsLeft: Bool = false
    var newDistance: Double = 150
    var showingAlert: Bool = false
}
