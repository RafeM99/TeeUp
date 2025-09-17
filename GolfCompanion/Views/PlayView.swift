//
//  PlayView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct PlayView: View {
    @State private var displayedCourse: Course = Course.courseExamples.first!
    @State private var scores: [(String, String, Int)] = []
    @State private var tee: Tee = Course.courseExamples.first!.tees.male.first!
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink(destination: {
                        CourseDetailView(course: displayedCourse)
                    }, label: {
                        Text("Course details")
                    })
                    
                    Text("Best score: \(scores.min(by: {$0.2 > $1.2})?.2)")
                    
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
                        
                        NavigationLink(destination: {
                            RoundView()
                        }, label: {
                            Text("Start Round")
                        })
                        .frame(minWidth: 150, minHeight: 60)
                        .background(Color.white)
                        .cornerRadius(20)
                        
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
        }
    }
}

#Preview {
    PlayView()
}
