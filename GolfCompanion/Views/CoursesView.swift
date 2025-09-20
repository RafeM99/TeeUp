//
//  CoursesView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 25/08/2025.
//

import SwiftUI

struct CoursesView: View {
    @State private var vm: CoursesViewModel = CoursesViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    List($vm.courses) { $course in
                        NavigationLink(destination: {
                            CourseDetailView(course: course)
                        }, label: {
                            HStack {
                                Image(systemName: course.isFavourite ? "star.fill" : "star")
                                    .onTapGesture {
                                        withAnimation {
                                            course.isFavourite.toggle()
                                            vm.courses.sort {$0.isFavourite && !$1.isFavourite}
                                        }
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
                    ForEach(vm.nearestCourses, id: \.id) {course in
                        NavigationLink(destination: {
                            CourseDetailView(course: course.course)
                        }, label: {
                            HStack {
                                Text("\(course.course.courseName)")
                                
                                Spacer()
                                
                                Text("\(course.distance, specifier: "%.1f")km away")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray)
                            }
                        })
                    }
                }, header: {
                    Text("Other courses near you")
                })
                
            }
            .navigationTitle("Courses")
            .onAppear(perform: {
                vm.updateLocation()
                vm.courses.sort {$0.isFavourite && !$1.isFavourite}
            })
        }
    }
}

#Preview {
    CoursesView()
}
