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
    @State private var status: CourseAPIManager.Status = .idle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if status == .loading {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Searching…")
                        .foregroundStyle(.secondary)
                }
            } else if courses.isEmpty {
                Text("No results found.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(courses, id: \.id) { course in
                    Text(course.courseName)
                }
            }
        }
        .task {
            let result = await fetchCourses(query: "Pebble")
            await MainActor.run {
                self.courses = result
            }
        }
    }
    
    private func fetchCourses(query: String) async -> [Course] {
        await withCheckedContinuation { continuation in
            apiManager.searchCourses(query: query) { courses, status in
                Task { @MainActor in
                    self.status = status
                }
                if let courses {
                    continuation.resume(returning: courses)
                }
            }
        }
    }
}

#Preview {
    TestSearchView()
}
