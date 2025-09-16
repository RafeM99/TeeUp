//
//  PlayView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct PlayView: View {
    @State private var displayedCourse: Course = Course.courseExamples.first!
    var scores: [(String, Int)] = []
    @State private var tee: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink(destination: {
                        
                    }, label: {
                        Text("Course details")
                    })
                    
                    Text("Best score: ")
                }, header: {
                    Text("Details")
                })
                
                Section(content: {
                    Picker("Select tee", selection: $tee) {
                        Section(content: {
                            ForEach(displayedCourse.tees.male, id:\.id) { tee in
                                Text(tee.teeName).tag(tee.teeName)
                            }
                        }, header: {
                            Text("Male tees")
                        })
                        
                        Section(content: {
                            ForEach(displayedCourse.tees.female, id:\.id) { tee in
                                Text(tee.teeName).tag(tee.teeName)
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
                        
                    
                        
                        Button(action: {
                            
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
            .navigationTitle("\(displayedCourse.courseName)")
        }
    }
}

#Preview {
    PlayView()
}
