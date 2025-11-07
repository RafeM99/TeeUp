//
//  GolfCompanionApp.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/07/2025.
//

import SwiftUI

@main
struct GolfCompanionApp: App {
    @State private var bag = Bag(clubs: Bag.examples)
    @State private var coursesVM = CoursesViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bag)
                .environment(coursesVM)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                coursesVM.updateLocation()
                
                for score in coursesVM.scoresList {
                    coursesVM.fetchCourseWithID(id: score.courseId)
                    if coursesVM.returnedCourseFromAPI != nil {
                        coursesVM.recentScores.append(CourseScore(score: score.score, course: coursesVM.returnedCourseFromAPI!, date: score.date))
                    } else {
                        print("No course found")
                    }
                    
                    coursesVM.returnedCourseFromAPI = nil
                }
            }
        }
    }
}
