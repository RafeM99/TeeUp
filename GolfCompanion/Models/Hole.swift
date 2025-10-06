//
//  Hole.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Hole: Identifiable, Hashable, Sendable, Decodable {
    var id: Int { number }
    var number: Int
    let par: Int
    let yardage: Int
    
    enum CodingKeys: String, CodingKey {
        case par
        case yardage
        //'number' is not in the API response
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.par = try container.decode(Int.self, forKey: .par)
        self.yardage = try container.decode(Int.self, forKey: .yardage)
        self.number = 0  // Placeholder
    }
        
    init(number: Int, par: Int, yardage: Int, handicap: Int? = nil) {
        self.number = number
        self.par = par
        self.yardage = yardage
    }
}
