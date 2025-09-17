//
//  AddScoreView.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 17/09/2025.
//

import SwiftUI

struct AddScoreView: View {
    @Binding var scores: [(String, String, Int)]
    @Binding var course: Course
    @Binding var isShowing: Bool
    
    @State var newScore: Double = 0.0
    @State var newTee: Tee = Course.courseExamples.first!.tees.male.first!
    
    var body: some View {
        List {
            Picker("Select tee", selection: $newTee) {
                Section(content: {
                    ForEach(course.tees.male, id:\.id) { tee in
                        Text(tee.teeName).tag(tee)
                    }
                }, header: {
                    Text("Male tees")
                })
                
                Section(content: {
                    ForEach(course.tees.female, id:\.id) { tee in
                        Text(tee.teeName).tag(tee)
                    }
                }, header: {
                    Text("Female tees")
                })
            }
            .onChange(of: newTee, {
                newScore = Double(newTee.parTotal)
            })
            
            VStack(alignment: .leading) {
                Text("Total score: \(newScore, specifier: "%.0f")")
                
                Slider(value: $newScore, in: 45...150, label: {
                    Text("Total score: ")
                }, minimumValueLabel: {
                    Text("45")
                }, maximumValueLabel: {
                    Text("150")
                })
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    let newScore = (course.courseName, newTee.teeName, Int(newScore))
                    scores.append(newScore)
                    isShowing = false
                }, label: {
                    Text("Add Score")
                })
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.3)])
    }
}

//#Preview {
//    AddScoreView()
//}
