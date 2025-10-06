//
//  TeeTypes.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 26/08/2025.
//

import Foundation

struct TeeTypes: Sendable, Decodable {
    var id = UUID()
    let female: [Tee]
    let male: [Tee]
}
