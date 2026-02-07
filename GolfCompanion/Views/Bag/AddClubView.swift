//
//  AddClubView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 08/07/2025.
//

import SwiftUI

struct AddClubView: View {
    @Environment(Bag.self) private var bag
    
    @Binding var isShowing: Bool
    
    @State private var vm = AddClubViewModel()
    
    var body: some View {
        List {
            TextField("Brand", text: $vm.newBrand)
            
            Picker("Club type", selection: $vm.newType) {
                ForEach(ClubType.allCases, id:\.self) { type in
                    Text("\(type.rawValue)")
                }
            }
            
            Toggle(isOn: $vm.newIsLeft, label: {
                Text("Left Handed")
            })
            
            VStack(alignment: .leading) {
                Text("Distance: \(vm.newDistance, specifier: "%.0f") yds")
                
                Slider(value: $vm.newDistance, in: 50...350, step: 5, label: {
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
                    vm.addClub(bag, $isShowing)
                }, label: {
                    Text("Add Club")
                        .font(.title2)
                })
                
                Spacer()
            }
            .padding(8)
        }
        .presentationDetents([.fraction(0.5)])
        .alert("No brand entered", isPresented: $vm.showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
