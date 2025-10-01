//
//  LocationTests.swift
//  LocationTests
//
//  Created by Rafe Marriott on 07/07/2025.
//

import Testing
@testable import GolfCompanion

struct LocationTests {
    @Test(" Testing distance calculation", arguments: [
            (33.5028, -82.0223, 37.3346, -122.0090, "3621.44"),
            (39.7997, -89.6558, 37.3346, -122.0090, "2810.79"),
            (36.5684, -121.9507, 37.3346, -122.0090, "85.35"),
            (56.3439, -2.8036, 37.3346, -122.0090, "8134.37"),
            (-37.8597, 145.0363, 37.3346, -122.0090, "12661.09")
        ])
    func distanceCalculationWithVariousCoordinates(courseLat: Double, courseLon: Double,userLat: Double, userLon: Double, expectedDistance: String) {
        let coursesViewModel = CoursesViewModel()
        let result = String(format: "%.2f",coursesViewModel.calculateDistance(courseLat: courseLat,courseLon: courseLon,userLat: userLat,userLon: userLon))
        #expect(result == expectedDistance)
    }
    
    @Test("Testing nearest courses", arguments: [(courseList: Course.courseExamples, userCoordinates: (37.3346, -122.0090), expectedResult: [
        CourseDistance(course: Course(
            clubName: "Pebble Beach Golf Links",
            courseName: "Pebble Beach",
            location: Location(
                address: "17-Mile Drive",
                city: "Pebble Beach",
                state: "CA",
                country: "USA",
                latitude: 36.5684,
                longitude: -121.9507
            ),
            tees: TeeTypes(
                female: [
                    Tee(
                        teeName: "Forward Tees",
                        totalYards: 5972,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 320), Hole(number: 2, par: 5, yardage: 446), Hole(number: 3, par: 4, yardage: 330), Hole(number: 4, par: 4, yardage: 269),
                            Hole(number: 5, par: 3, yardage: 110), Hole(number: 6, par: 5, yardage: 457), Hole(number: 7, par: 3, yardage: 99), Hole(number: 8, par: 4, yardage: 380),
                            Hole(number: 9, par: 4, yardage: 368), Hole(number: 10, par: 4, yardage: 389), Hole(number: 11, par: 4, yardage: 345), Hole(number: 12, par: 3, yardage: 160),
                            Hole(number: 13, par: 4, yardage: 340), Hole(number: 14, par: 5, yardage: 457), Hole(number: 15, par: 4, yardage: 324), Hole(number: 16, par: 4, yardage: 345),
                            Hole(number: 17, par: 3, yardage: 151), Hole(number: 18, par: 5, yardage: 482)
                        ]
                    ),
                    Tee(
                        teeName: "White Tees",
                        totalYards: 6350,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 350), Hole(number: 2, par: 5, yardage: 480), Hole(number: 3, par: 4, yardage: 355), Hole(number: 4, par: 4, yardage: 280),
                            Hole(number: 5, par: 3, yardage: 120), Hole(number: 6, par: 5, yardage: 480), Hole(number: 7, par: 3, yardage: 110), Hole(number: 8, par: 4, yardage: 400),
                            Hole(number: 9, par: 4, yardage: 400), Hole(number: 10, par: 4, yardage: 410), Hole(number: 11, par: 4, yardage: 360), Hole(number: 12, par: 3, yardage: 175),
                            Hole(number: 13, par: 4, yardage: 360), Hole(number: 14, par: 5, yardage: 480), Hole(number: 15, par: 4, yardage: 350), Hole(number: 16, par: 4, yardage: 370),
                            Hole(number: 17, par: 3, yardage: 160), Hole(number: 18, par: 5, yardage: 510)
                        ]
                    )
                ],
                male: [
                    Tee(
                        teeName: "Black Tees",
                        totalYards: 6828,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 377), Hole(number: 2, par: 5, yardage: 516), Hole(number: 3, par: 4, yardage: 390), Hole(number: 4, par: 4, yardage: 331),
                            Hole(number: 5, par: 3, yardage: 195), Hole(number: 6, par: 5, yardage: 504), Hole(number: 7, par: 3, yardage: 106), Hole(number: 8, par: 4, yardage: 427),
                            Hole(number: 9, par: 4, yardage: 481), Hole(number: 10, par: 4, yardage: 446), Hole(number: 11, par: 4, yardage: 374), Hole(number: 12, par: 3, yardage: 201),
                            Hole(number: 13, par: 4, yardage: 393), Hole(number: 14, par: 5, yardage: 572), Hole(number: 15, par: 4, yardage: 396), Hole(number: 16, par: 4, yardage: 403),
                            Hole(number: 17, par: 3, yardage: 177), Hole(number: 18, par: 5, yardage: 543)
                        ]
                    )
                ]
            )
        ), distance: 85.35),
        CourseDistance(course: Course(
            clubName: "City Park Golf Club",
            courseName: "Lakeside Course",
            location: Location(
                address: "123 Park Blvd",
                city: "Springfield",
                state: "IL",
                country: "USA",
                latitude: 39.7997,
                longitude: -89.6558
            ),
            tees: TeeTypes(
                female: [
                    Tee(
                        teeName: "Red Tees",
                        totalYards: 2500,
                        parTotal: 36,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 342), Hole(number: 2, par: 3, yardage: 144), Hole(number: 3, par: 4, yardage: 369), Hole(number: 4, par: 5, yardage: 459),
                            Hole(number: 5, par: 3, yardage: 139), Hole(number: 6, par: 4, yardage: 351), Hole(number: 7, par: 4, yardage: 365), Hole(number: 8, par: 3, yardage: 157),
                            Hole(number: 9, par: 4, yardage: 378)
                        ]
                    )
                ],
                male: [
                    Tee(
                        teeName: "White Tees",
                        totalYards: 3010,
                        parTotal: 35,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 380), Hole(number: 2, par: 3, yardage: 160), Hole(number: 3, par: 4, yardage: 410), Hole(number: 4, par: 5, yardage: 510),
                            Hole(number: 5, par: 3, yardage: 155), Hole(number: 6, par: 4, yardage: 390), Hole(number: 7, par: 4, yardage: 405), Hole(number: 8, par: 3, yardage: 175),
                            Hole(number: 9, par: 4, yardage: 420)
                        ]
                    ),
                    Tee(
                        teeName: "Blue Tees",
                        totalYards: 3250,
                        parTotal: 35,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 410), Hole(number: 2, par: 3, yardage: 180), Hole(number: 3, par: 4, yardage: 440), Hole(number: 4, par: 5, yardage: 540),
                            Hole(number: 5, par: 3, yardage: 165), Hole(number: 6, par: 4, yardage: 420), Hole(number: 7, par: 4, yardage: 435), Hole(number: 8, par: 3, yardage: 190),
                            Hole(number: 9, par: 4, yardage: 470)
                        ]
                    )
                ]
            )
        ), distance: 2810.79),
        CourseDistance(course: Course(
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
        ), distance: 3621.44),
        CourseDistance(course: Course(
            clubName: "St Andrews Links",
            courseName: "Old Course",
            location: Location(
                address: "St Andrews Links, The Links, KY16 9JD",
                city: "St Andrews",
                state: "Fife",
                country: "Scotland",
                latitude: 56.3430,
                longitude: -2.8033
            ),
            tees: TeeTypes(
                female: [
                    Tee(
                        teeName: "Ladies’ Championship Tees",
                        totalYards: 6700,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 375),
                            Hole(number: 2, par: 4, yardage: 452),
                            Hole(number: 3, par: 4, yardage: 398),
                            Hole(number: 4, par: 4, yardage: 480),
                            Hole(number: 5, par: 5, yardage: 570),
                            Hole(number: 6, par: 4, yardage: 414),
                            Hole(number: 7, par: 4, yardage: 371),
                            Hole(number: 8, par: 3, yardage: 174),
                            Hole(number: 9, par: 4, yardage: 352),
                            Hole(number: 10, par: 4, yardage: 386),
                            Hole(number: 11, par: 3, yardage: 174),
                            Hole(number: 12, par: 4, yardage: 348),
                            Hole(number: 13, par: 4, yardage: 465),
                            Hole(number: 14, par: 5, yardage: 614),
                            Hole(number: 15, par: 4, yardage: 455),
                            Hole(number: 16, par: 4, yardage: 418),
                            Hole(number: 17, par: 4, yardage: 495),
                            Hole(number: 18, par: 4, yardage: 356)
                        ]
                    )
                ],
                male: [
                    Tee(
                        teeName: "Championship Tees",
                        totalYards: 7313,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 4, yardage: 375),
                            Hole(number: 2, par: 4, yardage: 452),
                            Hole(number: 3, par: 4, yardage: 398),
                            Hole(number: 4, par: 4, yardage: 480),
                            Hole(number: 5, par: 5, yardage: 570),
                            Hole(number: 6, par: 4, yardage: 414),
                            Hole(number: 7, par: 4, yardage: 371),
                            Hole(number: 8, par: 3, yardage: 174),
                            Hole(number: 9, par: 4, yardage: 352),
                            Hole(number: 10, par: 4, yardage: 386),
                            Hole(number: 11, par: 3, yardage: 174),
                            Hole(number: 12, par: 4, yardage: 348),
                            Hole(number: 13, par: 4, yardage: 465),
                            Hole(number: 14, par: 5, yardage: 614),
                            Hole(number: 15, par: 4, yardage: 455),
                            Hole(number: 16, par: 4, yardage: 418),
                            Hole(number: 17, par: 4, yardage: 495),
                            Hole(number: 18, par: 4, yardage: 356)
                        ]
                    )
                ]
            )
        ), distance: 8134.37),
        CourseDistance(course: Course(
            clubName: "Royal Melbourne Golf Club",
            courseName: "West Course",
            location: Location(
                address: "Cheltenham Rd, Black Rock, Victoria 3193",
                city: "Melbourne",
                state: "Victoria",
                country: "Australia",
                latitude: -37.9731,
                longitude: 145.0308
            ),
            tees: TeeTypes(
                female: [
                    Tee(
                        teeName: "Ladies’ Tees (Composite)",
                        totalYards: 5849,  // per sources for “Ladies (Red)” on Composite layout :contentReference[oaicite:0]{index=0}
                        parTotal: 77,      // sometimes the ladies’ par is adjusted in composite setup :contentReference[oaicite:1]{index=1}
                        holes: [
                            // For brevity, only a few sample holes; complete data would mirror composite routing
                            Hole(number: 1, par: 5, yardage: 421),
                            Hole(number: 2, par: 4, yardage: 0),  // placeholder if par/yardage differs
                            Hole(number: 3, par: 4, yardage: 0),
                            // … fill in remaining 18 holes based on composite chart
                            Hole(number: 17, par: 5, yardage: 480),
                            Hole(number: 18, par: 4, yardage: 432)
                        ]
                    )
                ],
                male: [
                    Tee(
                        teeName: "Blue Tees (Men’s Championship Composite)",
                        totalYards: 6996,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 5, yardage: 476),
                            // ... fill all composite hole yardages
                            Hole(number: 10, par: 4, yardage: 476),
                            Hole(number: 17, par: 5, yardage: 569),
                            Hole(number: 18, par: 4, yardage: 432)
                        ]
                    ),
                    Tee(
                        teeName: "White Tees (Men’s Composite alternate)",
                        totalYards: 6597,
                        parTotal: 72,
                        holes: [
                            Hole(number: 1, par: 5, yardage: 465),
                            // ... etc
                            Hole(number: 17, par: 5, yardage: 509),
                            Hole(number: 18, par: 4, yardage: 400)
                        ]
                    )
                ]
            )
        ), distance: 12661.09)])])
    func nearestCourseCalculationWithFiveCourses(courseList: [Course], userCoordinates: (Double, Double), expectedResult: [CourseDistance]) {
        // arrange
        let coursesViewModel = CoursesViewModel()
        //act
        let result = coursesViewModel.findNearestCourses(courseList: courseList, userCoordinates: userCoordinates)
        //assert
        #expect(result.map {$0.course.courseName} == expectedResult.map {$0.course.courseName})
        #expect(result.map {String(format: "%.2f",$0.distance)} == expectedResult.map {String($0.distance)})
    }

}
