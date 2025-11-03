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
    var sortedPairedResults: [(RecommendedNearbyCourse, Course)] = []
    
    func updateLocation() {
        locationDataManager.requestLocation { [weak self] coordinate in
            guard let self else { return }
            self.coordinates = coordinate
            print("User location: \(coordinate.0), \(coordinate.1)")
            
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
            
            Task {
                await self.checkIfCoursesInAPI(courseList: self.nearbyRecommendedCourses)
                print(self.nearbyRecommendedCourses)
            }
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
    
    @MainActor
    func checkIfCoursesInAPI(courseList: [RecommendedNearbyCourse]) async {
        guard !courseList.isEmpty else {
            self.nearestCoursesToDisplay = []
            self.nearestCourses = []
            self.message = "No nearby courses found"
            return
        }

        isLoading = true
        message = nil

        var pairedResults: [(RecommendedNearbyCourse, Course)] = []

        for course in courseList {
            let query = self.normalise(course.name)
            print("(API query):", query)
            guard !query.isEmpty else { continue }
            try? await Task.sleep(nanoseconds: 500_000_000)
            let apiResults = await withCheckedContinuation { continuation in
                self.fetchCourses(query: query) { results in
                    continuation.resume(returning: results)
                }
            }
            if let firstMatch = apiResults.first {
                pairedResults.append((course, firstMatch))
            }
        }

        isLoading = false
        sortedPairedResults = pairedResults.sorted { $0.0.distanceKm < $1.0.distanceKm }
        self.nearestCoursesToDisplay = sortedPairedResults.prefix(5).map { $0.0 }
        self.nearestCourses = sortedPairedResults.prefix(5).map { $0.1 }
            
        self.message = self.nearestCourses.isEmpty ? "No matching courses found in API" : nil
    }
    
    func normalise(_ name: String) -> String {
        let lowercased = name.lowercased()
        let trimmed = lowercased.trimmingCharacters(in: .whitespacesAndNewlines)
        let noPunctuation = trimmed.components(separatedBy: .punctuationCharacters).joined()
        let reduced = noPunctuation.replacingOccurrences(of: "golf club", with: "")
                                    .replacingOccurrences(of: "golf course", with: "")
                                    .replacingOccurrences(of: "gc", with: "")
                                    .replacingOccurrences(of: "golf centre", with: "")
                                    .replacingOccurrences(of: "pitch", with: "")
        let singleSpaced = reduced.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        return singleSpaced.trimmingCharacters(in: .whitespaces)
    }
}
