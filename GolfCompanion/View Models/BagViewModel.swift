//
//  BagViewModel.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 26/11/2025.
//

import Foundation

@Observable
class BagViewModel {
    var isShowingSheet: Bool = false
    
    // delete a club from the bag
    func deleteClub(_ club: Club, from bag: Bag) {
        bag.clubs.removeAll{$0.id == club.id}
        bag.clubs.sort{$0.distance > $1.distance}
        FileManager.default.save(to: "bagFile", object: bag)
    }
}
