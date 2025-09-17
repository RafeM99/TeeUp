//
//  Tee.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Tee: Identifiable, Hashable, Sendable {
    let id = UUID()
    let teeName: String
    let totalYards: Int
    let parTotal: Int
    let holes: [Hole]
}
