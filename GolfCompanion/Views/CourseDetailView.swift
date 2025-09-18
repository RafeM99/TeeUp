//
//  CourseDetailView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct CourseDetailView: View {
    @State var course: Course
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Club name: \(course.clubName)")
                }
                
                Section(content: {
                    Text("\(course.location.address)")
                    Text("\(course.location.city)")
                    Text("\(course.location.state)")
                    Text("\(course.location.country)")
                }, header: {
                    Text("Address")
                })
                
                Section(content: {
                    ForEach(course.tees.male, id: \.id) { tee in
                        NavigationLink(destination: {
                            TeeDetailView(tee: tee)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text("\(tee.teeName)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Total yards: \(tee.totalYards)")
                                Text("Par: \(tee.parTotal)")
                            } 
                        })
                    }
                }, header: {
                    Text("Male Tees")
                })
                
                Section(content: {
                    ForEach(course.tees.female, id: \.id) { tee in
                        NavigationLink(destination: {
                            TeeDetailView(tee: tee)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text("\(tee.teeName)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Total yards: \(tee.totalYards)")
                                Text("Par: \(tee.parTotal)")
                            }
                        })
                    }
                }, header: {
                    Text("Female Tees")
                })
            }
            .navigationTitle("\(course.courseName)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        course.isFavourite.toggle()
                    }, label: {
                        Image(systemName: course.isFavourite ? "star.fill" : "star")
                    })
                    .symbolEffect(.bounce, value: course.isFavourite)
                }
            }
        }
    }
}

#Preview {
    CourseDetailView(course: Course(
        clubName: "Augusta National Golf Club",
        courseName: "Augusta National",
        location: Location(
            address: "2604 Washington Rd",
            city: "Augusta",
            state: "GA",
            country: "USA",
            latitude: 33.5028,
            longitude: -82.0223
        ),
        tees: TeeTypes(
            female: [
                Tee(
                    teeName: "Forward Tees",
                    totalYards: 6365,
                    parTotal: 72,
                    holes: [
                        Hole(par: 4, yardage: 365), Hole(par: 5, yardage: 515), Hole(par: 4, yardage: 340), Hole(par: 3, yardage: 170),
                        Hole(par: 4, yardage: 400), Hole(par: 3, yardage: 165), Hole(par: 4, yardage: 330), Hole(par: 5, yardage: 480),
                        Hole(par: 4, yardage: 395), Hole(par: 4, yardage: 480), Hole(par: 4, yardage: 400), Hole(par: 3, yardage: 145),
                        Hole(par: 5, yardage: 455), Hole(par: 4, yardage: 380), Hole(par: 5, yardage: 475), Hole(par: 3, yardage: 145),
                        Hole(par: 4, yardage: 370), Hole(par: 4, yardage: 385)
                    ]
                )
            ],
            male: [
                Tee(
                    teeName: "Masters Tees",
                    totalYards: 7445,
                    parTotal: 72,
                    holes: [
                        Hole(par: 4, yardage: 445), Hole(par: 5, yardage: 575), Hole(par: 4, yardage: 350), Hole(par: 3, yardage: 240),
                        Hole(par: 4, yardage: 455), Hole(par: 3, yardage: 180), Hole(par: 4, yardage: 450), Hole(par: 5, yardage: 570),
                        Hole(par: 4, yardage: 460), Hole(par: 4, yardage: 495), Hole(par: 4, yardage: 505), Hole(par: 3, yardage: 155),
                        Hole(par: 5, yardage: 510), Hole(par: 4, yardage: 440), Hole(par: 5, yardage: 530), Hole(par: 3, yardage: 170),
                        Hole(par: 4, yardage: 440), Hole(par: 4, yardage: 465)
                    ]
                ),
                Tee(
                    teeName: "Member Tees",
                    totalYards: 6980,
                    parTotal: 72,
                    holes: [
                        Hole(par: 4, yardage: 400), Hole(par: 5, yardage: 520), Hole(par: 4, yardage: 320), Hole(par: 3, yardage: 200),
                        Hole(par: 4, yardage: 410), Hole(par: 3, yardage: 165), Hole(par: 4, yardage: 420), Hole(par: 5, yardage: 500),
                        Hole(par: 4, yardage: 425), Hole(par: 4, yardage: 450), Hole(par: 4, yardage: 455), Hole(par: 3, yardage: 140),
                        Hole(par: 5, yardage: 460), Hole(par: 4, yardage: 400), Hole(par: 5, yardage: 490), Hole(par: 3, yardage: 160),
                        Hole(par: 4, yardage: 400), Hole(par: 4, yardage: 425)
                    ]
                )
            ]
        )
    ))
}
