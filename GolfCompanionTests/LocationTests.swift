//
//  LocationTests.swift
//  LocationTests
//
//  Created by Rafe Marriott on 07/07/2025.
//

import Testing
@testable import GolfCompanion

struct LocationTests {

    @Test("Testing distance calculator", arguments: [(courseLat: 33.5028, courseLon: -82.0223, userLat: 37.3346, userLon: -122.0090, expectedDistance: "3621.44"), (courseLat: 39.7997, courseLon: -89.6558, userLat: 37.3346, userLon: -122.0090, expectedDistance: "2810.79"), (courseLat: 36.5684, courseLon: -121.9507, userLat: 37.3346, userLon: -122.0090, expectedDistance: "85.35")])
    func distanceCalculationWithVariousCoordinates(courseLat: Double, courseLon: Double, userLat: Double, userLon: Double, expectedDistance: String) async throws {
        // arrange
        let coursesView = CoursesView()
        //act
        let result = String(format: "%.2f", coursesView.calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userLat, userLon: userLon))
        //assert
        #expect(result == expectedDistance)
    }

}
