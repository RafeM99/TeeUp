//
//  PlayView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct PlayView: View {
    @Environment(CoursesViewModel.self) private var coursesVM
    @Environment(PlayViewModel.self) private var vm
    
    private var selectedCourseScores: [CourseIDScore] {
        guard let courseId = vm.displayedCourse?.courseId else { return [] }
        return coursesVM.scoresList.filter { $0.courseId == courseId }
    }
    
    var body: some View {
        @Bindable var bindableVM = vm
        
        NavigationStack {
            Form {
                Section(content: {
                    if let course = vm.displayedCourse {
                        NavigationLink(destination: {
                            CourseDetailView(course: course)
                        }, label: {
                            Text("Course details")
                        })
                    } else {
                        Text("Course details")
                            .foregroundStyle(.secondary)
                    }
                    
                    if let best = vm.findLowestScore(scores: selectedCourseScores) {
                        Text("Best score: \(best.score) - \(best.teeName)")
                    } else {
                        Text("Best score: N/A")
                    }
                    
                    Button("Add a previous score") {
                        vm.isShowingSheet = true
                    }
                }, header: {
                    Text("Details")
                })
                
                Section(content: {
                    Picker("Select tee", selection: $bindableVM.tee) {
                        if let maleTees = vm.displayedCourse?.tees.male {
                            Section(content: {
                                ForEach(maleTees, id: \.id) { tee in
                                    Text(tee.teeName).tag(tee as Tee?)
                                }
                            }, header: {
                                Text("Male tees")
                            })
                        }
                        
                        if let femaleTees = vm.displayedCourse?.tees.female {
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
                            if vm.tee == nil {
                                vm.showingAlert = true
                            } else {
                                vm.startRound = true
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
            .navigationTitle(vm.displayedCourse?.courseName ?? "Loading…")
            .sheet(isPresented: $bindableVM.isShowingSheet, onDismiss: {
                vm.isShowingSheet = false
            }, content: {
                if let course = vm.displayedCourse {
                    AddScoreView(course: .constant(course), isShowing: $bindableVM.isShowingSheet)
                }
            })
            .navigationDestination(isPresented: $bindableVM.startRound) {
                if let course = vm.displayedCourse, let tee = vm.tee {
                    RoundView(course: .constant(course),
                              tee: Binding(get: { tee }, set: { vm.tee = $0 }),
                              roundScores: $bindableVM.roundScores,
                              showingRoundSummary: $bindableVM.showingRoundSummary,
                              showingRoundView: $bindableVM.startRound),
                }
            }
            .alert("No tee selected", isPresented: $bindableVM.showingAlert) {
                Button("OK", role: .cancel) {}
            }
            .sheet(isPresented: $bindableVM.showingRoundSummary, onDismiss: {
                vm.showingRoundSummary = false
            }, content: {
                if let tee = vm.tee {
                    NavigationStack {
                        RoundSummaryView(tee: Binding(get: { tee }, set: { vm.tee = $0 }), scores: $bindableVM.roundScores, showingSheet: $bindableVM.showingRoundSummary)
                    }
                }
            })
            .searchable(text: $bindableVM.query, isPresented: $bindableVM.isSearchPresented, prompt: "Enter course or club name...")
            .overlay(alignment: .center) {
                if vm.isSearchPresented, let _ = vm.displayedCourse {
                    PlaySearchView(query: $bindableVM.query, isLoading: $bindableVM.isLoading, selectedCourse: Binding(get: { vm.displayedCourse! }, set: { vm.displayedCourse = $0 }), isPresented: $bindableVM.isSearchPresented)
                    .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    PlayView()
        .environment(Bag(clubs: Bag.examples))
        .environment(CoursesViewModel())
        .environment(PlayViewModel(coursesVM: CoursesViewModel()))
}
