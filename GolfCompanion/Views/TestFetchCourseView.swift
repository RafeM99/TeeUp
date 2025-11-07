//
//  TestFetchCourseView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/11/2025.
//

import SwiftUI

struct TestFetchCourseView: View {
    private let apiManager = CourseAPIManager()
    @State private var isLoading = false
    @State private var message: String? = nil
    @State private var course: Course? = nil
    @State private var courseID: String = ""
    
    var body: some View {
        VStack {
            TextField("id", text: $courseID)
                .onSubmit { fetchCourseWithID(id: Int(courseID) ?? 0) }
            
            if course != nil {
                Text("\(course?.courseName ?? "None found")")
            }
        }
    }
    
    private func fetchCourseWithID(id: Int) {
        guard !(id == 0) else { return }

        isLoading = true
        message = nil

        apiManager.fetchCourseWithID(id: id) { course in
            Task { @MainActor in
                self.isLoading = false
                self.course = course
                if course == nil {
                    self.message = "Course not found"
                }
            }
        }
    }
}

#Preview {
    TestFetchCourseView()
}
