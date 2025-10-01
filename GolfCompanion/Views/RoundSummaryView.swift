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
    @Binding var showingSheet: Bool
    
    var totalScore: Int {
        scores.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Final score")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("\(totalScore)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Text(getParComparison(userTotal: totalScore, teeTotal: tee.parTotal))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(parColor(userTotal: totalScore, teeTotal: tee.parTotal))
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal)
                    
                    Scorecard_View(tee: $tee, scores: $scores)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    func getParComparison(userTotal: Int, teeTotal: Int) -> String {
        let parDifference = userTotal - teeTotal
        
        if parDifference == 0 {
            return "E"
        } else if parDifference > 0 {
            return "+" + String(parDifference)
        } else {
            return String(parDifference)
        }
    }
    
    func parColor(userTotal: Int, teeTotal: Int) -> Color {
        let diff = userTotal - teeTotal
        if diff == 0 {
            return .gray
        } else if diff > 0 {
            return .red
        } else {
            return .green
        }
    }
}


#Preview {
    NavigationStack {
        if let sampleTee = Course.courseExamples.first?.tees.male.first {
            RoundSummaryView(tee: .constant(sampleTee), scores: .constant(Array(repeating: 4, count: 18)), showingSheet: .constant(true))
        } else {
            Text("No sample tee available")
        }
    }
}
