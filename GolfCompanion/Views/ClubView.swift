//
//  ClubView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 08/07/2025.
//

import SwiftUI

struct ClubView: View {
    @State var club: Club
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        List {
            Text("Brand: \(club.brand)")
            Text("Distance: \(club.distance, specifier: "%.0f") yds")
            
            if club.isLeftHanded == true {
                Text("Left Handed")
            } else {
                Text("Right Handed")
            }
            
        }
        .navigationTitle(club.type.rawValue)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isShowingSheet = true
                }, label: {
                    Text("Edit")
                        .padding([.top, .leading, .bottom], 10)
                })
            }
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: {
            isShowingSheet = false
        }, content: {
            EditClubView(club: club, isShowing: $isShowingSheet)
        })
    }
}

#Preview {
    ClubView(club: Club(type: .driver, brand: "Titleist", isLeftHanded: false, distance: 250))
}

