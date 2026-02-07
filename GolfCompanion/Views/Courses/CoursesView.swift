//
//  CoursesView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 25/08/2025.
//

import SwiftUI
import Observation

struct CoursesView: View {
    @Environment(CoursesViewModel.self) private var vm
    
    private let apiManager = CourseAPIManager()
    @State private var query: String = ""
    @State private var isLoading = false
    @State private var isSearchPresented = false
    
    var body: some View {
        @Bindable var bindableVM = vm
        
        NavigationStack {
            Form {
                // favourited courses
                Section(content: {
                    ForEach(vm.favouritedCourses) { course in
                        NavigationLink(destination: {
                            CourseDetailView(course: course)
                        }, label: {
                            Text("\(course.courseName)")
                        })
                    }
                }, header: {
                    Text("Favourited Courses")
                })
                
                // recent rounds
                Section(content: {
                    List(vm.recentScores) { score in
                        NavigationLink(destination: {
                            CourseDetailView(course: score.course)
                        }, label: {
                            HStack {
                                Image(systemName: score.course.isFavourite ? "star.fill" : "star")
                                    .onTapGesture {
                                        withAnimation {
                                            score.course.isFavourite.toggle()

                                            if score.course.isFavourite == true {
                                                vm.favouritedIDs.append(score.course.courseId)
                                                FileManager.default.save(to: "favouritedIDsFile", object: vm.favouritedIDs)
                                            } else {
                                                vm.favouritedIDs.removeAll { $0 == score.course.courseId }
                                                FileManager.default.save(to: "favouritedIDsFile", object: vm.favouritedIDs)
                                            }

                                            vm.recentScores.sort { $0.course.isFavourite && !$1.course.isFavourite }
                                        }
                                    }
                                    .foregroundColor(.blue)
                                    .symbolEffect(.bounce, value: score.course.isFavourite)
                                
                                VStack(alignment: .leading) {
                                    Text("\(score.course.courseName)")
                                    Text("\(score.teeName)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(score.score)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text(vm.getTimeSinceRound(date: score.date))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        })
                    }
                }, header: {
                    Text("Recent rounds")
                })
                
                // recommended courses
                Section(content: {
                    if vm.isLoading {
                        ProgressView("Finding nearby courses…")
                    } else if let message = vm.message, vm.sortedPairedResults.isEmpty {
                        Text(message)
                            .foregroundStyle(.secondary)
                    } else if !vm.sortedPairedResults.isEmpty {
                        ForEach(vm.sortedPairedResults, id: \.1.id) { pairedResult in
                            NavigationLink(destination: {
                                CourseDetailView(course: pairedResult.1)
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(pairedResult.1.courseName)
                                            .font(.headline)
                                        Text(pairedResult.1.clubName)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(pairedResult.0.distanceKm, specifier: "%.1f")km away")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            })
                        }
                    } else {
                        // Initial state before location search starts
                        ProgressView("Finding nearby courses…")
                    }
                }, header: {
                    Text("Other courses near you")
                })
                
            }
            .navigationTitle("Courses")
            .onAppear(perform: {
                vm.courses.sort {$0.isFavourite && !$1.isFavourite}
            })
            .searchable(text: $query, isPresented: $isSearchPresented, prompt: "Enter course or club name...")
            .onChange(of: query) {
                print("CoursesView query changed to:", query)
            }
            .overlay(alignment: .center) {
                if isSearchPresented {
                    CourseSearchView(query: $query, isLoading: $isLoading)
                        .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    CoursesView()
        .environment(CoursesViewModel())
}
