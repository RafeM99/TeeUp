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
    var scoresList: [CourseScore] = [CourseScore(score: 75, courseId: 7118, date: Date().addingTimeInterval(10000)), CourseScore(score: 80, courseId: 24636, date: Date().addingTimeInterval(50000))]
    
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
    
    // Tokenize a name using the same normalization pipeline but returning tokens
    private func normalizedTokens(_ name: String) -> [String] {
        let norm = normalise(name)
        return norm.split(separator: " ").map { String($0) }
    }

    // Simple Jaccard similarity over token sets
    private func jaccardSimilarity(_ a: [String], _ b: [String]) -> Double {
        let setA = Set(a)
        let setB = Set(b)
        if setA.isEmpty && setB.isEmpty { return 1.0 }
        let intersection = setA.intersection(setB).count
        let union = setA.union(setB).count
        return union == 0 ? 0.0 : Double(intersection) / Double(union)
    }
    
    // Extract a human-readable name from Course via reflection
    private func candidateName(from c: Course) -> String {
        let mirror = Mirror(reflecting: c)
        let preferredKeys = ["name", "title", "courseName"]
        for child in mirror.children {
            if let label = child.label, preferredKeys.contains(label), let value = child.value as? String {
                return value
            }
        }
        // Fallback to description
        return String(describing: c)
    }
    
    // Try to extract latitude/longitude from Course via reflection
    private func apiCoordinates(from c: Course) -> (Double, Double)? {
        let mirror = Mirror(reflecting: c)

        // Direct properties on the root
        var lat: Double? = nil
        var lon: Double? = nil
        for child in mirror.children {
            guard let label = child.label else { continue }
            switch label.lowercased() {
            case "latitude", "lat":
                if let v = child.value as? Double { lat = v }
                if let v = child.value as? Float { lat = Double(v) }
                if let v = child.value as? String, let d = Double(v) { lat = d }
            case "longitude", "lon", "lng":
                if let v = child.value as? Double { lon = v }
                if let v = child.value as? Float { lon = Double(v) }
                if let v = child.value as? String, let d = Double(v) { lon = d }
            case "coordinate", "coordinates", "location":
                // Inspect nested structs/dictionaries
                let nested = Mirror(reflecting: child.value)
                for n in nested.children {
                    if let nlabel = n.label?.lowercased() {
                        if (nlabel == "latitude" || nlabel == "lat"), lat == nil {
                            if let v = n.value as? Double { lat = v }
                            if let v = n.value as? Float { lat = Double(v) }
                            if let v = n.value as? String, let d = Double(v) { lat = d }
                        }
                        if (nlabel == "longitude" || nlabel == "lon" || nlabel == "lng"), lon == nil {
                            if let v = n.value as? Double { lon = v }
                            if let v = n.value as? Float { lon = Double(v) }
                            if let v = n.value as? String, let d = Double(v) { lon = d }
                        }
                    }
                }
            default:
                break
            }
        }

        if let lat = lat, let lon = lon { return (lat, lon) }
        return nil
    }

    // Compute a richer similarity: token Jaccard + containment bonuses
    private func scoreNameSimilarity(targetName: String, candidateName: String) -> Double {
        let targetTokens = normalizedTokens(targetName)
        let candidateTokens = normalizedTokens(candidateName)
        var score = jaccardSimilarity(targetTokens, candidateTokens)

        // Containment bonuses using normalized strings without spaces
        let targetNorm = normalise(targetName).replacingOccurrences(of: " ", with: "")
        let candidateNorm = normalise(candidateName).replacingOccurrences(of: " ", with: "")

        if !targetNorm.isEmpty && candidateNorm.contains(targetNorm) { score += 0.35 }
        if !candidateNorm.isEmpty && targetNorm.contains(candidateNorm) { score += 0.25 }

        // Prefix/suffix light bonuses
        if candidateNorm.hasPrefix(targetNorm) || targetNorm.hasPrefix(candidateNorm) { score += 0.1 }
        if candidateNorm.hasSuffix(targetNorm) || targetNorm.hasSuffix(candidateNorm) { score += 0.05 }

        // Clamp to [0, 1]
        return max(0.0, min(1.0, score))
    }

    // Choose the best API course match by token similarity to the target name
    private func bestAPIMatch(for target: RecommendedNearbyCourse, from candidates: [Course]) -> (Course, Double)? {
        var best: (Course, Double)? = nil
        for c in candidates {
            let candName = candidateName(from: c)
            let sim = scoreNameSimilarity(targetName: target.name, candidateName: candName)
            if let currentBest = best {
                if sim > currentBest.1 { best = (c, sim) }
            } else {
                best = (c, sim)
            }
        }
        return best
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
            let normalized = self.normalise(course.name)
            let normalizedTokenCount = normalized.split(separator: " ").count
            let query: String = (normalized.count < 4 || normalizedTokenCount < 2) ? course.name : normalized

            print("(API query):", query)
            guard !query.isEmpty else { continue }
            try? await Task.sleep(nanoseconds: 500_000_000)
            let apiResults = await withCheckedContinuation { continuation in
                self.fetchCourses(query: query) { results in
                    continuation.resume(returning: results)
                }
            }
            if !apiResults.isEmpty {
                if let (best, score) = self.bestAPIMatch(for: course, from: apiResults) {
                    let bestName = candidateName(from: best)
                    let targetNorm = self.normalise(course.name)
                    let bestNorm = self.normalise(bestName)
                    let containsStrong = !targetNorm.isEmpty && (bestNorm.contains(targetNorm) || targetNorm.contains(bestNorm))
                    let threshold = 0.25
                    if containsStrong || score >= threshold {
                        var geoAccepted = true
                        if let apiCoord = self.apiCoordinates(from: best) {
                            let targetCoord = course.coordinates
                            let distToTarget = self.calculateDistance(courseLat: apiCoord.0, courseLon: apiCoord.1, userLat: targetCoord.0, userLon: targetCoord.1)
                            let distToUser = self.calculateDistance(courseLat: apiCoord.0, courseLon: apiCoord.1, userLat: self.coordinates.0, userLon: self.coordinates.1)
                            // Reject if the API candidate is far from both the MapKit item and the user (likely wrong country)
                            let maxKmFromTarget = 150.0
                            let maxKmFromUser = 300.0
                            if distToTarget > maxKmFromTarget && distToUser > maxKmFromUser {
                                geoAccepted = false
                                print("Rejected by geo sanity: best='\(bestName)' distToTarget=\(String(format: "%.1f", distToTarget))km distToUser=\(String(format: "%.1f", distToUser))km")
                            }
                        }
                        if geoAccepted {
                            pairedResults.append((course, best))
                            print("Matched '\(course.name)' -> '\(bestName)' with score: \(score))")
                        } else {
                            print("No geographically plausible match for: \(course.name). Candidates: \(apiResults.count)")
                        }
                    } else {
                        print("No sufficiently similar match for: \(course.name). Best: \(bestName) score=\(score). Candidates: \(apiResults.count)")
                    }
                } else {
                    print("No candidates to match for: \(course.name)")
                }
            }
        }

        isLoading = false
        sortedPairedResults = pairedResults.sorted { $0.0.distanceKm < $1.0.distanceKm }
        self.nearestCoursesToDisplay = sortedPairedResults.prefix(5).map { $0.0 }
        self.nearestCourses = sortedPairedResults.prefix(5).map { $0.1 }
            
        self.message = self.nearestCourses.isEmpty ? "No nearby courses found" : nil
    }
    
    func normalise(_ name: String) -> String {
        // Base lowercase + diacritics folding
        let original = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var s = original.lowercased()
        s = s.folding(options: .diacriticInsensitive, locale: .current)
        s = s.replacingOccurrences(of: "&", with: " and ")

        // Remove common tokens via word-boundary regex to avoid partial removals
        let tokensToRemove = [
            "golf club", "golf course", "golf centre", "golf and leisure", "golf & leisure",
            "leisure", "club", "centre", "driving range", "academy", "gc", "pitch"
        ]
        for token in tokensToRemove {
            let pattern = "\\b" + NSRegularExpression.escapedPattern(for: token) + "\\b"
            s = s.replacingOccurrences(of: pattern, with: " ", options: [.regularExpression])
        }

        // Remove punctuation
        s = s.components(separatedBy: .punctuationCharacters).joined()
        // Collapse multiple spaces
        s = s.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)

        // If the normalized string is too generic, fall back to the original
        let tokenCount = s.split(separator: " ").count
        if s.count < 4 || tokenCount < 2 {
            return original.lowercased()
        }
        return s
    }
}
