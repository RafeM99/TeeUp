//
//  PlayView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct PlayView: View {
    @State private var displayedCourse: Course = Course.courseExamples.first!
    @State private var scores: [(String, String, Int)] = [("Augusta National", "Masters Tees", 92), ("Augusta National", "Member Tees", 72)]
    @State private var tee: Tee = Course.courseExamples.first!.tees.male.first!
    @State private var isShowingSheet: Bool = false
    @State private var startRound = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    NavigationLink(destination: {
                        CourseDetailView(course: displayedCourse)
                    }, label: {
                        Text("Course details")
                    })
                    
                    if let best = findLowestScore(scores: scores) {
                        Text("Best score: \(best.2) - \(best.1)")
                    } else {
                        Text("Best score: N/A")
                    }
                    
                    Button("Add a previous score") {
                        isShowingSheet = true
                    }
                }, header: {
                    Text("Details")
                })
                
                Section(content: {
                    Picker("Select tee", selection: $tee) {
                        Section(content: {
                            ForEach(displayedCourse.tees.male, id:\.id) { tee in
                                Text(tee.teeName).tag(tee)
                            }
                        }, header: {
                            Text("Male tees")
                        })
                        
                        Section(content: {
                            ForEach(displayedCourse.tees.female, id:\.id) { tee in
                                Text(tee.teeName).tag(tee)
                            }
                        }, header: {
                            Text("Female tees")
                        })
                    }
                }, header: {
                    Text("Play")
                })
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            startRound = true
                        } label: {
                            Text("Start Round")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .frame(minWidth: 200, minHeight: 70)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets())
                        
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(displayedCourse.courseName)
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                isShowingSheet = false
            }, content: {
                AddScoreView(scores: $scores, course: $displayedCourse, isShowing: $isShowingSheet)
            })
            .navigationDestination(isPresented: $startRound) {
                RoundView(course: $displayedCourse, tee: $tee)
            }
        }
    }
    
    func findLowestScore(scores: [(String, String, Int)]) -> (String, String, Int)? {
        let best = scores.min(by: { $0.2 < $1.2 })
        return best
    }
}

#Preview {
    PlayView()
}
