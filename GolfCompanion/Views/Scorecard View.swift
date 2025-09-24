//
//  Scorecard View.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 24/09/2025.
//

import SwiftUI

import SwiftUI

struct Scorecard_View: View {
    @State var tee: Tee
    
    var body: some View {
        VStack {
            ForEach(tee.holes, id: \.id) { hole in
                Text(String(hole.number))
            }
        }
    }
}


#Preview {
    Scorecard_View(tee: (Course.courseExamples.first?.tees.male.first)!)
}
