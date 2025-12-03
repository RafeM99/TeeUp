//
//  CourseSearchViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 01/12/2025.
//

import Foundation
import SwiftUI

@MainActor @Observable
class CourseSearchViewModel {
    let apiManager = CourseAPIManager()
    var courses: [Course] = []
    var message: String? = nil
    var searchTask: Task<Void, Never>? = nil
    
    func fetchCourses(query: String, _ isLoading: Binding<Bool>, _ coursesVm: CoursesViewModel) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading.wrappedValue = true
        message = nil

        apiManager.searchCourses(query: trimmed) { results in
            Task { @MainActor in
                isLoading.wrappedValue = false
                
                let updatedCourses = results
                for i in 0..<updatedCourses.count {
                    if coursesVm.favouritedIDs.contains(updatedCourses[i].courseId) {
                        updatedCourses[i].isFavourite = true
                    }
                }
                
                self.courses = updatedCourses
                if updatedCourses.isEmpty {
                    self.message = "No results"
                }
            }
        }
    }
}
