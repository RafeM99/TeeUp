//
//  PlayViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 21/11/2025.
//

import Foundation

@MainActor @Observable
class PlayViewModel {
    private let coursesVM: CoursesViewModel
    
    var displayedCourse: Course? = nil
    var isShowingSheet: Bool = false
    var startRound = false
    var tee: Tee? = nil
    var showingAlert: Bool = false
    var roundScores: [Int] = []
    var showingRoundSummary: Bool = false
    var query: String = ""
    var isLoading = false
    var isSearchPresented = false
    
    init(coursesVM: CoursesViewModel) {
        self.coursesVM = coursesVM
    }
    
    func findLowestScore(scores: [CourseIDScore]) -> CourseIDScore? {
        let best = scores.min(by: { $0.score < $1.score })
        return best
    }
    
    func findScoresForSelectedCourse(id: Int) -> [CourseIDScore] {
        var scores: [CourseIDScore] = []
        
        for score in coursesVM.scoresList {
            if score.courseId == id {
                scores.append(score)
            }
        }
        
        return scores
    }
}
