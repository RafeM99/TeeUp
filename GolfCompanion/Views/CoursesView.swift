//
//  CoursesView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 25/08/2025.
//

import SwiftUI

struct CoursesView: View {
    @State var courses = Course.courseExamples
    
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
                    
                }, header: {
                    Text("other courses near you")
                })
                
            }
            .navigationTitle("Courses")
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
    
    func findNearestCourses(courseList: [Course], userCoordinates: (Double, Double)) -> [String] {
        var distances: [(String, Double)] = []
        
        for course in courseList {
            let courseLat = course.location.latitude
            let courseLon = course.location.longitude
            
            let distance = calculateDistance(courseLat: courseLat, courseLon: courseLon, userLat: userCoordinates.0, userLon: userCoordinates.1)
            distances.append((course.courseName, distance))
        }
        
        distances.sort{$0.1 < $1.1}
        
        var nearestCourses: [String] = []
        
        for i in 0...4 {
            nearestCourses.append(distances[i].0)
        }
        
        return nearestCourses
    }
}

#Preview {
    CoursesView()
}
