//
//  LocationTests.swift
//  LocationTests
//
//  Created by Rafe Marriott on 07/07/2025.
//

import Testing
@testable import GolfCompanion

struct LocationTests {
    @MainActor @Test(" Testing distance calculation", arguments: [
            (33.5028, -82.0223, 37.3346, -122.0090, "3621.44"),
            (39.7997, -89.6558, 37.3346, -122.0090, "2810.79"),
            (36.5684, -121.9507, 37.3346, -122.0090, "85.35"),
            (56.3439, -2.8036, 37.3346, -122.0090, "8134.37"),
            (-37.8597, 145.0363, 37.3346, -122.0090, "12661.09")
        ])
    func distanceCalculationWithVariousCoordinates(courseLat: Double, courseLon: Double,userLat: Double, userLon: Double, expectedDistance: String) {
        let coursesViewModel = CoursesViewModel()
        let result = String(format: "%.2f",coursesViewModel.calculateDistance(courseLat: courseLat,courseLon: courseLon,userLat: userLat,userLon: userLon))
        #expect(result == expectedDistance)
    }
}
