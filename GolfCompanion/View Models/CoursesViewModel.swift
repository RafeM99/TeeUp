//
//  CoursesViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 13/09/2025.
//

import Foundation

@Observable
class CoursesViewModel {
    private let locationDataManager = LocationDataManager()
    var coordinates: (Double, Double) = (0.0, 0.0)
    var courses = Course.courseExamples
    var nearestCourses: [CourseDistance] = []
    
    func updateLocation() {
        //invokes the location handler instance's method to request location and passes it a closure representing the code to do when the location update responds!
        locationDataManager.requestLocation(completion: { coordinate in
            self.coordinates = coordinate
            self.nearestCourses = self.findNearestCourses(courseList: Course.courseExamples, userCoordinates: self.coordinates)
        })
    }
    
    // Calculates distance between two coordinates in km
    func calculateDistance(courseLat: Double, courseLon: Double, userLat: Double, userLon: Double) -> Double {
        let R = 6371.0 //Radius of Earth in km
        
        let dLat = (userLat - courseLat) * .pi / 180
        let dLon = (userLon - courseLon) * .pi / 180
        
        let radCourseLat = courseLat * .pi / 180
        let radUserLat = userLat * .pi / 180
        
        let a = sin(dLat / 2) * sin(dLat / 2) + cos(radCourseLat) * cos(radUserLat) * sin(dLon / 2) * sin(dLon / 2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = R * c
        return distance
    }
    
    func findNearestCourses(courseList: [Course], userCoordinates: (Double, Double)) -> [CourseDistance] {
        var distances: [(Course, Double)] = []
        
        for course in courseList {
            // Skip courses without coordinates
            guard let courseLat = course.location.latitude,
                  let courseLon = course.location.longitude else {
                continue
            }
            
            let distance = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userCoordinates.0, userLon: userCoordinates.1)
            distances.append((course, distance))
        }
        
        distances.sort { $0.1 < $1.1 }
        
        var nearestCourses: [CourseDistance] = []
        
        // Only take up to 5 courses (or fewer if less than 5 available)
        let count = min(5, distances.count)
        for i in 0..<count {
            nearestCourses.append(CourseDistance(course: distances[i].0, distance: distances[i].1))
        }
        
        return nearestCourses
    }
}
