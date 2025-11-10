//
//  CourseScore.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 07/11/2025.
//

import Foundation

struct CourseScore: Identifiable {
    let id = UUID()
    let score: Int
    let course: Course
    let date: Date
    let teeName: String
}
