//
//  RoundViewModel.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 28/11/2025.
//

import Foundation
import SwiftUI

@Observable
class RoundViewModel {
    var holeNumber: Int = 1
    var showingAlert: Bool = false
    var pendingScore: Int?
    var totalScore: Int = 0
    var showScorecard: Bool = false
    var showCaddy: Bool = false
    var showingCaddyAlert: Bool = false
    var recommendedClub: String = ""
    
    @MainActor func addScore(_ coursesVm: CoursesViewModel, _ score: Int, _ roundScores: Binding<[Int]>, _ tee: Binding<Tee>, _ course: Binding<Course>, _ showingRoundSummary: Binding<Bool>, _ showingRoundView: Binding<Bool>) {
        roundScores.wrappedValue.append(score)
        self.totalScore += score
        
        if self.holeNumber >= tee.wrappedValue.holes.count {
            self.pendingScore = nil
            
            coursesVm.scoresList.append(CourseIDScore(score: self.totalScore, courseId: course.wrappedValue.courseId, date: Date.now, teeName: tee.wrappedValue.teeName))
            
            FileManager.default.save(to: "scoresListFile", object: coursesVm.scoresList)
            
            showingRoundSummary.wrappedValue = true
            showingRoundView.wrappedValue = false
        } else {
            self.holeNumber += 1
            self.pendingScore = nil
        }
    }
}
