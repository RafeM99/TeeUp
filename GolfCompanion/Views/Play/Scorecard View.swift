//
//  Scorecard View.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 24/09/2025.
//

import SwiftUI

struct Scorecard_View: View {
    @Binding var tee: Tee
    @Binding var scores: [Int]
    
    var body: some View {
        let holes = tee.holes
        let frontCount = min(9, holes.count)
        let front = Array(holes.prefix(frontCount))
        let back = Array(holes.dropFirst(frontCount))
        let hasBack = !back.isEmpty
        
        // functions to sum attributes
        func sumPar(_ hs: [Hole]) -> Int {
            hs.reduce(0) { $0 + $1.par }
        }
        func sumYardage(_ hs: [Hole]) -> Int {
            hs.reduce(0) { $0 + $1.yardage }
        }
        // add scores for a given index range. Returns nil if there are no scores in that range yet.
        func sumScores(range: Range<Int>) -> Int? {
            guard !scores.isEmpty else { return nil }
            var total = 0
            var hasAny = false
            for i in range {
                if scores.indices.contains(i) {
                    total += scores[i]
                    hasAny = true
                }
            }
            return hasAny ? total : nil
        }
        
        let outPar = sumPar(front)
        let inPar = sumPar(back)
        let totalPar = outPar + inPar
        
        let outYardage = sumYardage(front)
        let inYardage = sumYardage(back)
        let totalYardage = outYardage + inYardage
        
        let outScore = sumScores(range: 0..<frontCount)
        let inScore = sumScores(range: frontCount..<(frontCount + back.count))
        let totalScore: Int? = {
            switch (outScore, inScore) {
            case let (o?, i?): return o + i
            case let (o?, nil): return o
            case let (nil, i?): return i
            default: return nil
            }
        }()
        let isRoundOver = scores.count >= holes.count
        
        return ScrollView {
            HStack(alignment: .top, spacing: 0) {
                // Hole column
                VStack {
                    Text("Hole")
                        .fontWeight(.bold)
                    Divider()
                        .frame(maxWidth: 60)
                        .background(Color.black)
                    
                    // Front nine
                    ForEach(front, id: \.id) { hole in
                        Text(String(hole.number))
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    // OUT subtotal after 9 (only if there is a back nine)
                    if hasBack {
                        Text("OUT")
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    // Back nine
                    ForEach(back, id: \.id) { hole in
                        Text(String(hole.number))
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    
                    if hasBack {
                        Text("IN").fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text("OUT").fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text("TOTAL").fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    } else {
                        // 9-hole course: show OUT and TOTAL only
                        Text("OUT").fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text("TOTAL").fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                }
                
                
                Divider()
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 4)
                    .background(Color.black)
                
                
                VStack {
                    Text("Par")
                        .fontWeight(.bold)
                    Divider()
                        .frame(maxWidth: 60)
                        .background(Color.black)
                    
                    ForEach(front, id: \.id) { hole in
                        Text(String(hole.par))
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    if hasBack {
                        Text(String(outPar))
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    ForEach(back, id: \.id) { hole in
                        Text(String(hole.par))
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                    
                    if hasBack {
                        Text(String(inPar))
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text(String(outPar))
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text(String(totalPar))
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    } else {
                        Text(String(outPar))
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                        Text(String(outPar)) // TOTAL equals OUT on a 9-hole card
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 60)
                            .background(Color.black)
                    }
                }
                
                
                Divider()
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 4)
                    .background(Color.black)
                
                
                
                VStack {
                    Text("Distance")
                        .fontWeight(.bold)
                    Divider()
                        .frame(maxWidth: 100)
                        .background(Color.black)
                    
                    ForEach(front, id: \.id) { hole in
                        Text("\(hole.yardage) yds")
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                    }
                    
                    if hasBack {
                        Text("\(outYardage) yds")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                    }
                    
                    ForEach(back, id: \.id) { hole in
                        Text("\(hole.yardage) yds")
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                    }
                    
                    if hasBack {
                        Text("\(inYardage) yds")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                        Text("\(outYardage) yds")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                        Text("\(totalYardage) yds")
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                    } else {
                        Text("\(outYardage) yds")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                        Text("\(outYardage) yds")
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 100)
                            .background(Color.black)
                    }
                }
                
                Divider()
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 4)
                    .background(Color.black)
                
                
                VStack {
                    Text("Score")
                        .fontWeight(.bold)
                    Divider()
                        .frame(maxWidth: 80)
                        .background(Color.black)
                    
                    // Front scores
                    ForEach(0..<front.count, id: \.self) { i in
                        Text(scores.indices.contains(i) ? String(scores[i]) : " ")
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                    }
                    
                    // OUT subtotal after 9 (only if there is a back nine)
                    if hasBack {
                        Text(outScore.map(String.init) ?? " ")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                    }
                    
                    // Back scores
                    ForEach(0..<back.count, id: \.self) { j in
                        let i = front.count + j
                        Text(scores.indices.contains(i) ? String(scores[i]) : " ")
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                    }
                    
                    // Bottom rows
                    if hasBack {
                        Text(isRoundOver ? (inScore.map(String.init) ?? " ") : " ")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                        Text(outScore.map(String.init) ?? " ")
                            .fontWeight(.semibold)
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                        Text(isRoundOver ? (totalScore.map(String.init) ?? " ") : " ")
                            .fontWeight(.bold)
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                    } else {
                        Text(outScore.map(String.init) ?? " ")
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                        Text(isRoundOver ? (outScore.map(String.init) ?? " ") : " ") // TOTAL equals OUT on a 9-hole card
                        Divider()
                            .frame(maxWidth: 80)
                            .background(Color.black)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Scorecard")
            .padding(.top, 20)
            .padding(.leading, 10)
        }
    }
}
