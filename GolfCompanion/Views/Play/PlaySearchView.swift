//
//  PlaySearchView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 17/11/2025.
//

import SwiftUI

struct PlaySearchView: View {
    @Environment(CoursesViewModel.self) private var vm
    
    @Binding var query: String
    @Binding var isLoading: Bool
    @Binding var selectedCourse: Course
    @Binding var isPresented: Bool
    
    private let apiManager = CourseAPIManager()
    @State var courses: [Course] = []
    @State private var message: String? = nil
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if !courses.isEmpty {
                    List(courses) { course in
                        Button(action: {
                            selectedCourse = course
                            isPresented = false
                        }, label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(course.courseName)
                                    .font(.headline)
                                Text(course.clubName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        })
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                } else if !isLoading, let message = message {
                    // centered message when there are no results
                    VStack {
                        Spacer()
                        Text(message)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 24)
                        Spacer()
                    }
                } else {
                    // when empty but no message, show nothing to avoid top padding
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .disabled(isLoading)
            .blur(radius: isLoading ? 1 : 0)
            
            if isLoading {
                // fullscreen loading overlay
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                VStack(spacing: 12) {
                    ProgressView("Searching…")
                        .progressViewStyle(.circular)
                        .tint(.accentColor)
                    
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
                .ignoresSafeArea()
            }
        }
        .onChange(of: query) {
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            // if cleared, reset state and stop loading
            guard !trimmed.isEmpty else {
                searchTask?.cancel()
                isLoading = false
                courses.removeAll()
                message = nil
                return
            }
            
            print("Query changed to:", query)

            // Cancel any in-flight debounce task
            searchTask?.cancel()

            // Debounce: wait briefly before firing the search
            searchTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
                fetchCourses(query: trimmed)
            }
        }
    }
    
    private func fetchCourses(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        message = nil

        apiManager.searchCourses(query: trimmed) { courses in
            Task { @MainActor in
                self.isLoading = false
                
                let updatedCourses = courses
                for i in 0..<updatedCourses.count {
                    if vm.favouritedIDs.contains(updatedCourses[i].courseId) {
                        updatedCourses[i].isFavourite = true
                    }
                }
                
                self.courses = courses
                if updatedCourses.isEmpty {
                    self.message = "No results"
                }
            }
        }
    }
}

//#Preview {
//    PlaySearchView()
//}
