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
                Task { @MainActor in
                    coursesVM.updateLocation()

                    coursesVM.recentScores.removeAll()
                    for score in coursesVM.scoresList {
                        if let course = await coursesVM.fetchCourseWithID(id: score.courseId) {
                            coursesVM.recentScores.append(CourseScore(score: score.score, course: course, date: score.date, teeName: score.teeName))
                        } else {
                            print("No course found")
                        }
                    }
                    coursesVM.filterRecentScores()
                }
            }
        }
    }
}
