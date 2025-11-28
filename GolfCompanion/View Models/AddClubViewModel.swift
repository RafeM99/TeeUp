//
//  AddClubViewModel.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 26/11/2025.
//

import Foundation
import SwiftUI

@Observable
class AddClubViewModel {
    var newType: ClubType = .driver
    var newBrand: String = ""
    var newIsLeft: Bool = false
    var newDistance: Double = 150
    var showingAlert: Bool = false
    
    func addClub(_ clubs: Binding<[Club]>, _ isShowing: Binding<Bool>) {
        if newBrand == "" {
            showingAlert = true
            return
        } else {
            let newClub = Club(type: self.newType, brand: self.newBrand, isLeftHanded: self.newIsLeft, distance: self.newDistance)
            clubs.wrappedValue.append(newClub)
            clubs.wrappedValue.sort(by: {$0.distance > $1.distance})
            isShowing.wrappedValue = false
        }
    }
}
