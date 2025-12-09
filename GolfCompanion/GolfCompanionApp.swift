//
//  GolfCompanionApp.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/07/2025.
//

import SwiftUI

@main
struct GolfCompanionApp: App {
    @State private var bag = FileManager.default.load(from: "bagFile") ?? Bag(clubs: [])
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
                    coursesVM.favouritedCourses.removeAll()
                    for id in coursesVM.favouritedIDs {
                        if let favouriteCourse = await coursesVM.fetchCourseWithID(id: id) {
                            coursesVM.favouritedCourses.append(favouriteCourse)
                        }
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
                    
                    if coursesVM.scoresList.isEmpty {
                        playVM.displayedCourse = await coursesVM.fetchCourseWithID(id: 12578)
                    } else if let recent = coursesVM.recentScores.first?.course.courseId,
                        let fetched = await coursesVM.fetchCourseWithID(id: recent) {
                            playVM.displayedCourse = fetched
                    }
                    
                    coursesVM.updateLocation()
                }
            }
        }
    }
}
