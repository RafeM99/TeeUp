//
//  CaddyView.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 01/10/2025.
//

import SwiftUI
import Observation

struct CaddyView: View {
    @Environment(Bag.self) private var bag
    @Environment(\.dismiss) private var dismiss
    
    @Binding var clubToHit: String
    @Binding var showingAlert: Bool
    
    @State private var vm = CaddyViewModel()
    
    var body: some View {
        List {
            LabeledContent("Distance to hole:") {
                HStack(spacing: 8) {
                    TextField("Distance", value: $vm.distance, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("yds")
                        .foregroundStyle(.secondary)
                }
            }
            
            Picker("Select lie:", selection: $vm.lie) {
                ForEach(CaddyViewModel.Lies.allCases, id:\.self) { lie in
                    Text(lie.rawValue)
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    vm.getRecommendedClub(bag, $clubToHit, $showingAlert)
                    
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
}

//#Preview {
//    CaddyView()
//        .environment(Bag(clubs: Bag.examples))
//}
