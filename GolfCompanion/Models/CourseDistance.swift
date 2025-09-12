//
//  CourseDistance.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 12/09/2025.
//

import Foundation

struct CourseDistance: Identifiable {
    let id = UUID()
    let course: Course
    let distance: Double
}
