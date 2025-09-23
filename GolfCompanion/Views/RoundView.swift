//
//  RoundView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 16/09/2025.
//

import SwiftUI

struct RoundView: View {
    @Binding var course: Course
    @Binding var tee: Tee
    
    @State private var holeNumber: Int = 1
    
    var body: some View {
        Form {
            Section {
                Text("Distance: \(tee.holes[holeNumber - 1].yardage)")
                Text("Par: \(tee.holes[holeNumber - 1].par)")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("Hole \(holeNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            })
        }
    }
}

//#Preview {
//    RoundView()
//}
