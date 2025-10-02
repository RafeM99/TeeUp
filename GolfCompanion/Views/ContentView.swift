//
//  ContentView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/07/2025.
//

import SwiftUI

struct ContentView: View {
    private let locationDataManager = LocationDataManager()
    
    var body: some View {
        TabView{
            BagView()
                .tabItem{
                    Label("Bag", image: "golf.bag")
                }
            CoursesView()
                .tabItem{
                    Label("Courses", image: "golf.flag.fill")
                }
            PlayView()
                .tabItem{
                    Label("Play", systemImage: "figure.golf")
                }
        }
        .onAppear(perform: {
            locationDataManager.requestAuthorisation()
        })
    }
}

#Preview {
    ContentView()
        .environment(Bag(clubs: Bag.examples))
}
