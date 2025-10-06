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
    @State private var isShowingSheet: Bool = false
    @State private var startRound = false
    @State private var tee: Tee? = nil
    @State var showingAlert: Bool = false
    @State var roundScores: [Int] = []
    @State var showingRoundSummary: Bool = false
    
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
                        if let maleTees = displayedCourse.tees.male {
                            Section(content: {
                                ForEach(maleTees, id: \.id) { tee in
                                    Text(tee.teeName).tag(tee as Tee?)
                                }
                            }, header: {
                                Text("Male tees")
                            })
                        }
                        
                        if let femaleTees = displayedCourse.tees.female {
                            Section(content: {
                                ForEach(femaleTees, id: \.id) { tee in
                                    Text(tee.teeName).tag(tee as Tee?)
                                }
                            }, header: {
                                Text("Female tees")
                            })
                        }
                    }
                }, header: {
                    Text("Play")
                })
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            if tee == nil {
                                showingAlert = true
                            } else {
                                startRound = true
                            }
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
                if let tee {
                    RoundView(course: $displayedCourse, tee: Binding(get: { tee }, set: { self.tee = $0 }), courseScores: $scores, roundScores: $roundScores, showingRoundSummary: $showingRoundSummary)
                }
            }
            .alert("No tee selected", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
            .sheet(isPresented: $showingRoundSummary, onDismiss: {
                showingRoundSummary = false
            }, content: {
                if let tee {
                    NavigationStack {
                        RoundSummaryView(tee: Binding(get: { tee }, set: { self.tee = $0 }), scores: $roundScores, showingSheet: $showingRoundSummary)
                    }
                }
            })
        }
    }
    
    func findLowestScore(scores: [(String, String, Int)]) -> (String, String, Int)? {
        let best = scores.min(by: { $0.2 < $1.2 })
        return best
    }
}

#Preview {
    PlayView()
        .environment(Bag(clubs: Bag.examples))
}
