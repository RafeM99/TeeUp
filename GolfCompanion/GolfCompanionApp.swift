//
//  GolfCompanionApp.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/07/2025.
//

import SwiftUI

@main
struct GolfCompanionApp: App {
    @State private var bag = Bag(clubs: Bag.examples)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bag)
        }
    }
}
