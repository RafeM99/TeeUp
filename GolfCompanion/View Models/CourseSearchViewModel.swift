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
    private var lastQueryID: Int = 0
    
    func fetchCourses(query: String, _ isLoading: Binding<Bool>, _ coursesVm: CoursesViewModel) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // cancel any ongoing search task
        searchTask?.cancel()
        
        // if the query is empty, clear state and return
        if trimmed.isEmpty {
            Task { @MainActor in
                isLoading.wrappedValue = false
                message = nil
                self.courses = []
            }
            return
        }
        
        // increment query ID to get the latest request
        lastQueryID &+= 1
        let currentQueryID = lastQueryID
        
        // debounce the request to avoid rate limits when typing quickly
        searchTask = Task { [weak self] in
            // wait 300ms, if a new query comes in, this task will be cancelled
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled, let self else { return }
            
            await MainActor.run {
                isLoading.wrappedValue = true
                message = nil
            }
            
            // call api
            self.apiManager.searchCourses(query: trimmed) { results in
                Task { @MainActor in
                    // ignore stale responses from older queries
                    guard currentQueryID == self.lastQueryID else { return }
                    
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
}

