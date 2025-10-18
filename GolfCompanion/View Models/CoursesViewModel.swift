//
//  CoursesViewModel.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 13/09/2025.
//

import Foundation
import MapKit
import CoreLocation

@MainActor @Observable
class CoursesViewModel {
    private let locationDataManager = LocationDataManager()
    var coordinates: (Double, Double) = (0.0, 0.0)
    var courses = Course.courseExamples
    var nearestCoursesToDisplay: [RecommendedNearbyCourse] = []
    var nearbyRecommendedCourses: [RecommendedNearbyCourse] = []
    var message: String? = nil
    var isLoading = false
    var golfCourseAPIResults: [Course] = []
    var nearestCourses: [Course] = []
    
    func updateLocation() {
        locationDataManager.requestLocation { [weak self] coordinate in
            guard let self else { return }
            self.coordinates = coordinate
            print("User location: \(coordinate.0), \(coordinate.1)")
//            self.nearestCourses = self.findNearestCourses(
//                courseList: Course.courseExamples,
//                userCoordinates: self.coordinates
//            )
            
            self.fetchNearbyCoursesWithMapKit(userLocation: self.coordinates)
        }
    }
    
    // Calculates distance between two coordinates in km
    func calculateDistance(courseLat: Double, courseLon: Double, userLat: Double, userLon: Double) -> Double {
        let course = CLLocation(latitude: courseLat, longitude: courseLon)
        let user = CLLocation(latitude: userLat, longitude: userLon)
        // distance(from:) returns meters; convert to kilometers
        return course.distance(from: user) / 1000.0
    }
    
//    func findNearestCourses(courseList: [Course], userCoordinates: (Double, Double)) -> [CourseDistance] {
//        // Guard against default or invalid coordinates
//        guard userCoordinates.0 != 0.0 || userCoordinates.1 != 0.0 else { return [] }
//        
//        var distances: [(Course, Double)] = []
//        
//        for course in courseList {
//            // Skip courses without coordinates
//            guard let courseLat = course.location.latitude,
//                  let courseLon = course.location.longitude else {
//                continue
//            }
//            
//            let distance = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userCoordinates.0, userLon: userCoordinates.1)
//            distances.append((course, distance))
//        }
//        
//        distances.sort { $0.1 < $1.1 }
//        
//        var nearestCourses: [CourseDistance] = []
//        
//        // Only take up to 5 courses (or fewer if less than 5 available)
//        let count = min(5, distances.count)
//        for i in 0..<count {
//            nearestCourses.append(CourseDistance(course: distances[i].0, distance: distances[i].1))
//        }
//        
//        return nearestCourses
//    }
    
    func sortNearestCoursesForLightweightMapItems(courseList: [LightweightMapItem], userCoordinates: (Double, Double)) -> [(LightweightMapItem, Double)] {
        // Guard against default or invalid coordinates
        guard userCoordinates.0 != 0.0 || userCoordinates.1 != 0.0 else { return [] }
        
        var courses: [(LightweightMapItem, Double)] = []
        
        for course in courseList {
            let courseLat = course.coordinates.0
            let courseLon = course.coordinates.1

            let distance = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userCoordinates.0, userLon: userCoordinates.1)
            courses.append((course, distance))
        }
        
        courses.sort { $0.1 < $1.1}
        
        return courses
    }
    
    func fetchNearbyCoursesWithMapKit(userLocation: (Double, Double)) {
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let userCenter = CLLocationCoordinate2D(latitude: userLocation.0, longitude: userLocation.1)
        let searchRegion = MKCoordinateRegion(center: userCenter, span: searchSpan)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.golf])
        searchRequest.naturalLanguageQuery = "golf course"
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let self else { return }
            guard let mapItems = response?.mapItems, error == nil else {
                // Optionally clear or keep old results
                self.nearbyRecommendedCourses = []
                return
            }
            
            let results = mapItems.map {
                LightweightMapItem(
                    name: $0.name ?? "No Name Found",
                    coordinates: ($0.placemark.coordinate.latitude, $0.placemark.coordinate.longitude)
                )
            }
            
            let sortedResults = self.sortNearestCoursesForLightweightMapItems(
                courseList: results,
                userCoordinates: userLocation
            )

            // Map to UI-friendly model and assign to the observable property
            self.nearbyRecommendedCourses = sortedResults.prefix(10).map { item, distance in
                RecommendedNearbyCourse(
                    name: item.name,
                    distanceKm: distance,
                    coordinates: item.coordinates
                )
            }
            self.checkIfCoursesInAPI(courseList: self.nearbyRecommendedCourses)
            print(nearestCourses)
        }
    }
    
    private func fetchCourses(query: String, completion: @escaping @MainActor ([Course]) -> Void) {
        let apiManager = CourseAPIManager()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { completion([]); return }

        apiManager.searchCourses(query: trimmed) { courses in
            Task { @MainActor in
                completion(courses)
            }
        }
    }
    
    func checkIfCoursesInAPI(courseList: [RecommendedNearbyCourse]) {
        guard !courseList.isEmpty else {
            self.nearestCoursesToDisplay = []
            self.message = "No nearby courses found"
            return
        }

        isLoading = true
        message = nil

        let group = DispatchGroup()
        var matches: [Course] = []

        for course in courseList {
            let query = course.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !query.isEmpty else { continue }

            group.enter()
            self.fetchCourses(query: query) { apiResults in
                if !apiResults.isEmpty {
                    matches.append(contentsOf: apiResults)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            // Keep raw API results for further use
            self.golfCourseAPIResults = matches

            // Intersect nearby list with API results by name to preserve distance ordering
            let apiNames = Set(matches.map { $0.courseName.lowercased() })
            let filtered = courseList.filter { apiNames.contains($0.name.lowercased()) }
            let sortedNearby = filtered.sorted { $0.distanceKm < $1.distanceKm }
            self.nearestCoursesToDisplay = Array(sortedNearby.prefix(5))

            // Map back to Course objects, keeping distance order and limiting to 5
            var nameToCourse: [String: Course] = [:]
            for course in matches {
                let key = course.courseName.lowercased()
                if nameToCourse[key] == nil {
                    nameToCourse[key] = course
                }
            }
            var orderedCourses: [Course] = []
            for item in sortedNearby {
                let key = item.name.lowercased()
                if let course = nameToCourse[key] {
                    orderedCourses.append(course)
                    if orderedCourses.count == 5 { break }
                }
            }
            self.nearestCourses = orderedCourses

            if self.nearestCourses.isEmpty {
                self.message = "No matching courses found in API"
            } else {
                self.message = nil
            }
        }
    }
}
