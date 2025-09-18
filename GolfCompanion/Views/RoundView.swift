//
//  RoundView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 16/09/2025.
//

import SwiftUI

struct RoundView: View {
    @Binding var course: Course
    
    @State private var holeNumber: Int = 1
    
    var body: some View {
        Form {
            Section {
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .title, content: {
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
