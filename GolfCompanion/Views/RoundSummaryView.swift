//
//  RoundSummaryView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 29/09/2025.
//

import SwiftUI

struct RoundSummaryView: View {
    @Binding var tee: Tee
    @Binding var scores: [Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Final score: ")
            
            Scorecard_View(tee: $tee, scores: $scores)
                .navigationTitle("Round Summary")
        }
        
    }
    
}

#Preview {
    if let sampleTee = Course.courseExamples.first?.tees.male.first {
        RoundSummaryView(tee: .constant(sampleTee), scores: .constant(Array(repeating: 4, count: 18)))
    } else {
        Text("No sample tee available")
    }
}
