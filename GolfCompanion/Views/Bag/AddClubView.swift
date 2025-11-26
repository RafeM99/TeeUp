//
//  AddClubView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 08/07/2025.
//

import SwiftUI

struct AddClubView: View {
    @Binding var clubs: [Club]
    @Binding var isShowing: Bool
    
    var body: some View {
        List {
            TextField("Brand", text: $newBrand)
            
            Picker("Club type", selection: $newType) {
                ForEach(ClubType.allCases, id:\.self) { type in
                    Text("\(type.rawValue)")
                }
            }
            
            Toggle(isOn: $newIsLeft, label: {
                Text("Left Handed")
            })
            
            VStack(alignment: .leading) {
                Text("Distance: \(newDistance, specifier: "%.0f") yds")
                
                Slider(value: $newDistance, in: 50...350, step: 5, label: {
                    Text("Distance")
                }, minimumValueLabel: {
                    Text("50 yds")
                }, maximumValueLabel: {
                    Text("350 yds")
                })
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    if newBrand == "" {
                        showingAlert = true
                    } else {
                        let newClub = Club(type: newType, brand: newBrand, isLeftHanded: newIsLeft, distance: newDistance)
                        clubs.append(newClub)
                        clubs.sort(by: {$0.distance > $1.distance})
                        isShowing = false
                    }
                }, label: {
                    Text("Add Club")
                        .font(.title2)
                })
                
                Spacer()
            }
            .padding(8)
        }
        .presentationDetents([.fraction(0.5)])
        .alert("No brand entered", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

//#Preview {
//    AddClubView()
//}
