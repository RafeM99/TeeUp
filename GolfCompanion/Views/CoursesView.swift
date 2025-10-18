//
//  CoursesView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 25/08/2025.
//

import SwiftUI

struct CoursesView: View {
    @State private var vm: CoursesViewModel = CoursesViewModel()
    private let apiManager = CourseAPIManager()
    @State private var query: String = ""
    @State private var isLoading = false
    @State private var isSearchPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    List($vm.courses) { $course in
                        NavigationLink(destination: {
                            CourseDetailView(course: course)
                        }, label: {
                            HStack {
                                Image(systemName: course.isFavourite ? "star.fill" : "star")
                                    .onTapGesture {
                                        withAnimation {
                                            course.isFavourite.toggle()
                                            vm.courses.sort {$0.isFavourite && !$1.isFavourite}
                                        }
                                    }
                                    .foregroundColor(.blue)
                                    .symbolEffect(.bounce, value: course.isFavourite)
                                
                                Text("\(course.courseName)")
                            }
                        })
                    }
                }, header: {
                    
                })
                
                Section(content: {
                    if vm.isLoading {
                        ProgressView("Finding nearby courses…")
                    } else if let message = vm.message, vm.nearestCourses.isEmpty {
                        Text(message)
                            .foregroundStyle(.secondary)
                    } else if !vm.nearestCourses.isEmpty {
                        ForEach(vm.nearestCourses) { course in
                            NavigationLink(destination: {
                                CourseDetailView(course: course)
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(course.courseName)
                                            .font(.headline)
                                        Text(course.clubName)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                        
                                    if let match = vm.nearestCoursesToDisplay.first(where: { $0.name.lowercased() == course.courseName.lowercased() }) {
                                        Text("\(match.distanceKm, specifier: "%.1f")km away")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
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
                vm.updateLocation()
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
}
