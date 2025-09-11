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
}

#Preview {
    CoursesView()
}
