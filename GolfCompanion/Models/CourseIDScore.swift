//
//  CourseIDScore.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/11/2025.
//

import Foundation

struct CourseIDScore: Identifiable {
    let id = UUID()
    let score: Int
    let courseId: Int
    let date: Date
    let teeName: String
}
