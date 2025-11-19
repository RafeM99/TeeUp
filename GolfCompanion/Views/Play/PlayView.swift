//
//  PlayView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct PlayView: View {
    @Environment(CoursesViewModel.self) private var vm
    
    @State private var displayedCourse: Course = Course.courseExamples.first!
    @State private var selectedCourseScores: [CourseIDScore] = []
    @State private var isShowingSheet: Bool = false
    @State private var startRound = false
    @State private var tee: Tee? = nil
    @State var showingAlert: Bool = false
    @State var roundScores: [Int] = []
    @State var showingRoundSummary: Bool = false
    @State private var query: String = ""
    @State private var isLoading = false
    @State private var isSearchPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    NavigationLink(destination: {
                        CourseDetailView(course: displayedCourse)
                    }, label: {
                        Text("Course details")
                    })
                    
                    if let best = findLowestScore(scores: selectedCourseScores) {
                        Text("Best score: \(best.score) - \(best.teeName)")
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
                AddScoreView(course: $displayedCourse, isShowing: $isShowingSheet)
            })
            .navigationDestination(isPresented: $startRound) {
                if let tee {
                    RoundView(course: $displayedCourse, tee: Binding(get: { tee }, set: { self.tee = $0 }), roundScores: $roundScores, showingRoundSummary: $showingRoundSummary)
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
            .searchable(text: $query, isPresented: $isSearchPresented, prompt: "Enter course or club name...")
            .overlay(alignment: .center) {
                if isSearchPresented {
                    PlaySearchView(query: $query, isLoading: $isLoading, selectedCourse: $displayedCourse, isPresented: $isSearchPresented)
                        .transition(.opacity)
                }
            }
            .onAppear {
                selectedCourseScores = findScoresForSelectedCourse(id: displayedCourse.courseId)
            }
        }
    }
    
    func findLowestScore(scores: [CourseIDScore]) -> CourseIDScore? {
        let best = scores.min(by: { $0.score < $1.score })
        return best
    }
    
    func findScoresForSelectedCourse(id: Int) -> [CourseIDScore] {
        var scores: [CourseIDScore] = []
        
        for score in vm.scoresList {
            if score.courseId == id {
                scores.append(score)
            }
        }
        
        return scores
    }
}

#Preview {
    PlayView()
        .environment(Bag(clubs: Bag.examples))
        .environment(CoursesViewModel())
}
