//
//  AddScoreView.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 17/09/2025.
//

import SwiftUI

struct AddScoreView: View {
    @Environment(CoursesViewModel.self) private var vm
    
    @Binding var course: Course
    @Binding var isShowing: Bool
    
    @State var newScore: Double = 0.0
    @State var newTee: Tee?
    @State var newDate: Date = Date.now
    
    var body: some View {
        List {
            Picker("Select tee", selection: $newTee) {
                if let maleTees = course.tees.male {
                    Section(content: {
                        ForEach(maleTees, id: \.id) { tee in
                            Text(tee.teeName).tag(tee as Tee?)
                        }
                    }, header: {
                        Text("Male tees")
                    })
                }
                
                if let femaleTees = course.tees.female {
                    Section(content: {
                        ForEach(femaleTees, id: \.id) { tee in
                            Text(tee.teeName).tag(tee as Tee?)
                        }
                    }, header: {
                        Text("Female tees")
                    })
                }
            }
            .onChange(of: newTee) {
                if let tee = newTee {
                    newScore = Double(tee.parTotal)
                }
            }
            
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
            
            DatePicker("Round date", selection: $newDate, displayedComponents: [.date])
            
            HStack {
                Spacer()
                
                Button(action: {
                    guard let tee = newTee else { return }
                    let newScore = CourseIDScore(score: Int(newScore), courseId: course.courseId, date: newDate, teeName: tee.teeName)
                    vm.scoresList.append(newScore)
                    
                    FileManager.default.save(to: "scoresListFile", object: vm.scoresList)
                    isShowing = false
                }, label: {
                    Text("Add Score")
                })
                .disabled(newTee == nil)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.4)])
        .onAppear {
            // Set initial tee selection
            if newTee == nil {
                newTee = course.tees.male?.first ?? course.tees.female?.first
                if let tee = newTee {
                    newScore = Double(tee.parTotal)
                }
            }
        }
    }
}
