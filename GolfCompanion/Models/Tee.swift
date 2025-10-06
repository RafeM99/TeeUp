//
//  Tee.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Tee: Identifiable, Hashable, Sendable, Decodable {
    var id: String { teeName }
    let teeName: String
    let totalYards: Int
    let parTotal: Int
    let holes: [Hole]
    
    enum CodingKeys: String, CodingKey {
        case teeName = "tee_name"
        case totalYards = "total_yards"
        case parTotal = "par_total"
        case holes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teeName = try container.decode(String.self, forKey: .teeName)
        self.totalYards = try container.decode(Int.self, forKey: .totalYards)
        self.parTotal = try container.decode(Int.self, forKey: .parTotal)
            
        // Decode holes and assign numbers
        var decodedHoles = try container.decode([Hole].self, forKey: .holes)
        for (index, _) in decodedHoles.enumerated() {
            var hole = decodedHoles[index]
            hole.number = index + 1  // Assign hole numbers 1-18
            decodedHoles[index] = hole
        }
        self.holes = decodedHoles
    }
        
    // Keep existing init for manual creation
    init(teeName: String, totalYards: Int, parTotal: Int, holes: [Hole]) {
        self.teeName = teeName
        self.totalYards = totalYards
        self.parTotal = parTotal
        self.holes = holes
    }
}
