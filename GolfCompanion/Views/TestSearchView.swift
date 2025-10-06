//
//  TestSearchView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 05/10/2025.
//

import SwiftUI

struct TestSearchView: View {
    private let apiManager = CourseAPIManager()
    @State private var courses: [Course] = []
    @State private var query: String = ""
    @State private var isLoading = false
    @State private var message: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Search courses", text: $query)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { fetchCourses(query: query) }
        }
        
        HStack(spacing: 12) {
            Button("Search") {
                fetchCourses(query: query)
            }
            .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }

        if isLoading {
            ProgressView("Searching…")
                .padding(.vertical, 8)
        } else if let message = message, courses.isEmpty {
            Text(message)
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
        }

        List(courses) { course in
            VStack(alignment: .leading, spacing: 2) {
                Text(course.clubName)
                    .font(.headline)
                Text(course.courseName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
                self.courses = courses
                if courses.isEmpty {
                    self.message = "No results"
                }
            }
        }
    }
}

#Preview {
    TestSearchView()
}
