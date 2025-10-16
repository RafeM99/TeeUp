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
    var nearestCourses: [CourseDistance] = []
    
    func updateLocation() {
        locationDataManager.requestLocation { [weak self] coordinate in
            guard let self else { return }
            self.coordinates = coordinate
            print("User location: \(coordinate.0), \(coordinate.1)")
            self.nearestCourses = self.findNearestCourses(
                courseList: Course.courseExamples,
                userCoordinates: self.coordinates
            )
        }
    }
    
    // Calculates distance between two coordinates in km
    func calculateDistance(courseLat: Double, courseLon: Double, userLat: Double, userLon: Double) -> Double {
        let course = CLLocation(latitude: courseLat, longitude: courseLon)
        let user = CLLocation(latitude: userLat, longitude: userLon)
        // distance(from:) returns meters; convert to kilometers
        return course.distance(from: user) / 1000.0
    }
    
    func findNearestCourses(courseList: [Course], userCoordinates: (Double, Double)) -> [CourseDistance] {
        // Guard against default or invalid coordinates
        guard userCoordinates.0 != 0.0 || userCoordinates.1 != 0.0 else { return [] }
        
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
    
//    func fetchNearbyCoursesWithMapKit() async {
//        let (lat, lon) = coordinates
//        let localCourses = courses
//        // if coordiates are still defualt (0,0), exit function
//        guard lat != 0.0 || lon != 0.0 else { return }
//        
//        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        let region = MKCoordinateRegion(
//            center: center,
//            latitudinalMeters: 30_000,
//            longitudinalMeters: 30_000
//        )
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "golf course"
//        request.resultTypes = .pointOfInterest
//        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.golf])
//        request.region = region
//
//        let search = MKLocalSearch(request: request)
//
//        do {
//            let response = try await search.start()
//
//            // MapKit results simplified
//            let items: [(name: String, coordinate: CLLocationCoordinate2D)] = response.mapItems.compactMap { item in
//                guard let name = item.name else { return nil }
//                return (name: name, coordinate: item.placemark.coordinate)
//            }
//
//            // Resolve against your in-memory courses first (Course.courseExamples) by name proximity
//            // If you later have API resolution, plug that in here.
//            var resolved: [(Course, Double)] = []
//
//            for item in items {
//                // Simple name match against known courses
//                let lower = item.name.lowercased()
//                if let match = localCourses.first(where: { c in
//                    c.courseName.lowercased() == lower ||
//                    c.clubName.lowercased() == lower ||
//                    c.courseName.lowercased().contains(lower) ||
//                    lower.contains(c.courseName.lowercased()) ||
//                    c.clubName.lowercased().contains(lower) ||
//                    lower.contains(c.clubName.lowercased())
//                }) {
//                    // Compute distance using your existing function
//                    if let courseLat = match.location.latitude, let courseLon = match.location.longitude {
//                        let d = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: lat, userLon: lon)
//                        resolved.append((match, d))
//                    }
//                }
//            }
//
//            // If nothing matched by name, just compute nearest from your known list by coordinates
//            if resolved.isEmpty {
//                let nearest = findNearestCourses(courseList: localCourses, userCoordinates: (lat, lon))
//                self.nearestCourses = nearest
//                return
//            }
//
//            // Sort by distance and limit to 5
//            resolved.sort { $0.1 < $1.1 }
//            let limited = resolved.prefix(5)
//            let mapped: [CourseDistance] = limited.map { pair in
//                CourseDistance(course: pair.0, distance: pair.1)
//            }
//
//            self.nearestCourses = mapped
//
//        } catch {
//            // On error, fall back to local nearest computation
//            let fallback = findNearestCourses(courseList: localCourses, userCoordinates: (lat, lon))
//            self.nearestCourses = fallback
//        }
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
        
        search.start { response, error in
            guard let mapItems = response?.mapItems else {
                return
            }
            
            let results = mapItems.map({LightweightMapItem(name: $0.name ?? "No Name Found", coordinates: ($0.placemark.coordinate.latitude, $0.placemark.coordinate.longitude))})
            
            let sortedResults = self.sortNearestCoursesForLightweightMapItems(courseList: results, userCoordinates: userLocation)
            for (item, distance) in sortedResults.prefix(10) {
                let km = String(format: "%.2f km", distance)
                print("\(item.name): \(km)")
            }
        }
    }
}
