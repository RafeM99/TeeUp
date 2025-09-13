//
//  CoursesView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 25/08/2025.
//

import SwiftUI

struct CoursesView: View {
    @State var courses = Course.courseExamples
    let locationDataManager: LocationDataManager = LocationDataManager()
    @State private var nearestCourses: [CourseDistance] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    List($courses) { $course in
                        NavigationLink(destination: {
                            CourseDetailView(course: course)
                        }, label: {
                            HStack {
                                Image(systemName: course.isFavourite ? "star.fill" : "star")
                                    .onTapGesture {
                                        course.isFavourite.toggle()
                                    }
                                    .foregroundColor(.blue)
                                    .symbolEffect(.bounce, value: course.isFavourite)
                                
                                Text("\(course.courseName)")
                            }
                        })
                    }
                    
                }, header: {
                    
                })
                
                Section(content: {
                    ForEach(nearestCourses, id: \.id) {course in
                        HStack {
                            Text("\(course.course.courseName)")
                            
                            Spacer()
                            
                            Text("\(course.distance, specifier: "%.1f") km away")
                        }
                        
                    }
                }, header: {
                    Text("Other courses near you")
                })
                
            }
            .navigationTitle("Courses")
            .onAppear(perform: {
                locationDataManager.updateLocation()
                nearestCourses = findNearestCourses(courseList: Course.courseExamples, userCoordinates: locationDataManager.coordinates)
            })
        }
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
            let courseLat = course.location.latitude
            let courseLon = course.location.longitude
            
            let distance = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userCoordinates.0, userLon: userCoordinates.1)
            distances.append((course, distance))
        }
        
        distances.sort{$0.1 < $1.1}
        
        var nearestCourses: [CourseDistance] = []
        
        for i in 0...4 {
            nearestCourses.append(CourseDistance(course: distances[i].0, distance: distances[i].1))
        }
        
        return nearestCourses
    }
}

#Preview {
    CoursesView()
}
