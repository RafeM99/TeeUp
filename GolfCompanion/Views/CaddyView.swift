//
//  CaddyView.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 01/10/2025.
//

import SwiftUI
import Observation

struct CaddyView: View {
    @Binding var clubToHit: String
    @Binding var showingAlert: Bool
    
    @Environment(Bag.self) private var bag
    @Environment(\.dismiss) private var dismiss
    
    @State private var distance: Double?
    @State private var lie: Lies = .fairway
    @State private var lieConstant: Double = 1.0
    
    var body: some View {
        List {
            LabeledContent("Distance to hole:") {
                HStack(spacing: 8) {
                    TextField("Distance", value: $distance, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("yds")
                        .foregroundStyle(.secondary)
                }
            }
            
            Picker("Select lie:", selection: $lie) {
                ForEach(Lies.allCases, id:\.self) { lie in
                    Text(lie.rawValue)
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: {
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
                        clubToHit = "Enter a valid distance"
                        return
                    }
                    
                    distanceToHole = distanceToHole * lieConstant
                    
                    // bag.clubs is sorted descending by distance
                    if let club = bag.clubs.last(where: { $0.distance >= distanceToHole }) {
                        // This yields the smallest club that still reaches the target.
                        clubToHit = club.type.rawValue
                    } else if let longest = bag.clubs.first {
                        // If no club reaches the target, pick the longest.
                        clubToHit = longest.type.rawValue
                    } else {
                        // No clubs in the bag
                        clubToHit = "No clubs in bag"
                    }
                    
                    showingAlert = true
                    
                }, label: {
                    Text("Calculate Distance")
                        .font(.title2)
                })
                
                Spacer()
            }
            .padding(8)
        }
        .presentationDetents([.fraction(0.3)])
    }
    
    enum Lies: String, CaseIterable {
        case fairway = "Fairway"
        case rough = "Rough"
        case heavyRough = "Heavy Rough"
        case greensideBunker = "Greenside Bunker"
        case fairwayBunker = "Fairway Bunker"
    }
}

//#Preview {
//    CaddyView()
//        .environment(Bag(clubs: Bag.examples))
//}
