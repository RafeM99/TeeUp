//
//  CourseIDScore.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/11/2025.
//

import Foundation

struct CourseIDScore: Identifiable, Decodable, Encodable {
    var id = UUID()
    let score: Int
    let courseId: Int
    let date: Date
    let teeName: String
}
