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
    @State private var coursesVM: CoursesViewModel
    @State private var playVM: PlayViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let courses = CoursesViewModel()
        _coursesVM = State(initialValue: courses)
        _playVM = State(initialValue: PlayViewModel(coursesVM: courses))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bag)
                .environment(coursesVM)
                .environment(playVM)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { @MainActor in
                    if let firstRecent = coursesVM.recentScores.first {
                        playVM.displayedCourse = firstRecent.course
                    } else if let sunningdale = await coursesVM.fetchCourseWithID(id: 12578) {
                        playVM.displayedCourse = sunningdale
                    }
                    
                    coursesVM.recentScores.removeAll()
                    for score in coursesVM.scoresList {
                        if let course = await coursesVM.fetchCourseWithID(id: score.courseId) {
                            coursesVM.recentScores.append(CourseScore(score: score.score, course: course, date: score.date, teeName: score.teeName))
                        } else {
                            print("No course found")
                        }
                    }
                    coursesVM.filterRecentScores()
                    
                    coursesVM.updateLocation()
                }
            }
        }
    }
}
