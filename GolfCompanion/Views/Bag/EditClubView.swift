//
//  EditClubView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 24/08/2025.
//

import SwiftUI

struct EditClubView: View {
    @Bindable var club: Club
    @Binding var isShowing: Bool
    
    var body: some View {
        List {
            TextField("Brand", text: $club.brand)
            
            Toggle(isOn: $club.isLeftHanded, label: {
                Text("Left Handed")
            })
            
            VStack(alignment: .leading) {
                Text("Distance: \(club.distance, specifier: "%.0f") yds")
                
                Slider(value: $club.distance, in: 50...350, step: 5, label: {
                    Text("Distance")
                }, minimumValueLabel: {
                    Text("50 yds")
                }, maximumValueLabel: {
                    Text("350 yds")
                })
            }
            
            HStack{
                Spacer()
                
                Button(action: {
                    isShowing = false
                }, label: {
                    Text("Done")
                        .font(.title2)
                })
                .padding(8)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.4)])
    }
}

//#Preview {
//    EditClubView()
//}
