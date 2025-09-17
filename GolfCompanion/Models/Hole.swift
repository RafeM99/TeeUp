//
//  Hole.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct Hole: Identifiable, Hashable, Sendable {
    let id = UUID()
    let par: Int
    let yardage: Int
}
