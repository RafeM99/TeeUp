//
//  CourseDetailView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import SwiftUI

struct CourseDetailView: View {
    @Environment(CoursesViewModel.self) private var vm
    
    @State var course: Course
    @State var rounds: [CourseIDScore] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Club name: \(course.clubName)")
                }
                
                Section(content: {
                    Text(course.location.displayText)
                }, header: {
                    Text("Address")
                })
                
                Section(content: {
                    ForEach(rounds) { round in
                        HStack {
                            Text(round.teeName)
                            
                            Spacer()
                            
                            Text("\(round.score)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(vm.getTimeSinceRound(date: round.date))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }, header: {
                    Text("Previous rounds")
                })
                
                if let maleTees = course.tees.male, !maleTees.isEmpty {
                    Section(content: {
                        ForEach(maleTees, id: \.id) { tee in
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
                }
                
                if let femaleTees = course.tees.female, !femaleTees.isEmpty {
                    Section(content: {
                        ForEach(femaleTees, id: \.id) { tee in
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
            }
            .navigationTitle("\(course.courseName)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        course.isFavourite.toggle()
                        
                        if course.isFavourite == true {
                            vm.favouritedIDs.append(course.courseId)
                            FileManager.default.save(to: "favouritedIDsFile", object: vm.favouritedIDs)
                        } else {
                            vm.favouritedIDs.removeAll { $0 == course.courseId }
                            FileManager.default.save(to: "favouritedIDsFile", object: vm.favouritedIDs)
                        }
                    }, label: {
                        Image(systemName: course.isFavourite ? "star.fill" : "star")
                    })
                    .symbolEffect(.bounce, value: course.isFavourite)
                }
            }
            .onAppear(perform: {
                searchForRounds(id: course.courseId)
            })
        }
    }
    
    func searchForRounds(id: Int) {
        for score in vm.scoresList {
            if id == score.courseId {
                rounds.append(score)
            }
        }
    }
}

#Preview {
    CourseDetailView(course: Course(
        courseId: 1,
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
                        Hole(number: 1, par: 4, yardage: 365), Hole(number: 2, par: 5, yardage: 515), Hole(number: 3, par: 4, yardage: 340), Hole(number: 4, par: 3, yardage: 170),
                        Hole(number: 5, par: 4, yardage: 400), Hole(number: 6, par: 3, yardage: 165), Hole(number: 7, par: 4, yardage: 330), Hole(number: 8, par: 5, yardage: 480),
                        Hole(number: 9, par: 4, yardage: 395), Hole(number: 10, par: 4, yardage: 480), Hole(number: 11, par: 4, yardage: 400), Hole(number: 12, par: 3, yardage: 145),
                        Hole(number: 13, par: 5, yardage: 455), Hole(number: 14, par: 4, yardage: 380), Hole(number: 15, par: 5, yardage: 475), Hole(number: 16, par: 3, yardage: 145),
                        Hole(number: 17, par: 4, yardage: 370), Hole(number: 18, par: 4, yardage: 385)
                    ]
                )
            ],
            male: [
                Tee(
                    teeName: "Masters Tees",
                    totalYards: 7445,
                    parTotal: 72,
                    holes: [
                        Hole(number: 1, par: 4, yardage: 445), Hole(number: 2, par: 5, yardage: 575), Hole(number: 3, par: 4, yardage: 350), Hole(number: 4, par: 3, yardage: 240),
                        Hole(number: 5, par: 4, yardage: 455), Hole(number: 6, par: 3, yardage: 180), Hole(number: 7, par: 4, yardage: 450), Hole(number: 8, par: 5, yardage: 570),
                        Hole(number: 9, par: 4, yardage: 460), Hole(number: 10, par: 4, yardage: 495), Hole(number: 11, par: 4, yardage: 505), Hole(number: 12, par: 3, yardage: 155),
                        Hole(number: 13, par: 5, yardage: 510), Hole(number: 14, par: 4, yardage: 440), Hole(number: 15, par: 5, yardage: 530), Hole(number: 16, par: 3, yardage: 170),
                        Hole(number: 17, par: 4, yardage: 440), Hole(number: 18, par: 4, yardage: 465)
                    ]
                ),
                Tee(
                    teeName: "Member Tees",
                    totalYards: 6980,
                    parTotal: 72,
                    holes: [
                        Hole(number: 1, par: 4, yardage: 400), Hole(number: 2, par: 5, yardage: 520), Hole(number: 3, par: 4, yardage: 320), Hole(number: 4, par: 3, yardage: 200),
                        Hole(number: 5, par: 4, yardage: 410), Hole(number: 6, par: 3, yardage: 165), Hole(number: 7, par: 4, yardage: 420), Hole(number: 8, par: 5, yardage: 500),
                        Hole(number: 9, par: 4, yardage: 425), Hole(number: 10, par: 4, yardage: 450), Hole(number: 11, par: 4, yardage: 455), Hole(number: 12, par: 3, yardage: 140),
                        Hole(number: 13, par: 5, yardage: 460), Hole(number: 14, par: 4, yardage: 400), Hole(number: 15, par: 5, yardage: 490), Hole(number: 16, par: 3, yardage: 160),
                        Hole(number: 17, par: 4, yardage: 400), Hole(number: 18, par: 4, yardage: 425)
                    ]
                )
            ]
        )
    ))
    .environment(CoursesViewModel())
}
