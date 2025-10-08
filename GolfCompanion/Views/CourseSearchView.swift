//
//  CourseSearchView.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 08/10/2025.
//

import SwiftUI

struct CourseSearchView: View {
    private let apiManager = CourseAPIManager()
    @State private var courses: [Course] = []
    @State private var query: String = ""
    @State private var isLoading = false
    @State private var message: String? = nil
    
    var body: some View {
        NavigationStack {
            if courses.isEmpty {
                Text("No results")
            }
        }
        .searchable(text: $query, prompt: "Enter course or club name...")
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
    CourseSearchView()
}
