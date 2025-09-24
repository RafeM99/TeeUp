//
//  TeeDetailView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 27/08/2025.
//

import SwiftUI

struct TeeDetailView: View {
    let tee: Tee
    
    var body: some View {
        List {
            ForEach(Array(tee.holes.enumerated()), id: \.offset) { index, hole in
                VStack(alignment: .leading) {
                    Text("Hole \(index + 1)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Par \(hole.par)")
                    Text("\(hole.yardage) yds")
                }
            }
            .navigationTitle("\(tee.teeName)")
        }
    }
}

#Preview {
    TeeDetailView(tee: Tee(
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
    ))
}
