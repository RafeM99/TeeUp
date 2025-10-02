//
//  BagView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 07/07/2025.
//

import SwiftUI
import Observation

struct BagView: View {
    @Environment(Bag.self) private var bag
    
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(bag.clubs, id: \.id) { club in
                NavigationLink(destination: {
                    ClubView(club: club)
                }, label: {
                    HStack {
                        Text(club.type.rawValue)
                            .font(.title3)
                            
                        Spacer()
                            
                        Text("\(club.distance, specifier: "%.0f") yds")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    .padding(.vertical, 8)
                })
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deleteClub(club)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Bag")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                isShowingSheet = false
            }, content: {
                @Bindable var bag = bag
                AddClubView(clubs: $bag.clubs, isShowing: $isShowingSheet)
            })
        }
    }
    func deleteClub(_ club: Club) {
        bag.clubs.removeAll{$0.id == club.id}
        bag.clubs.sort{$0.distance > $1.distance}
    }
}

#Preview {
    BagView()
        .environment(Bag(clubs: Bag.examples))
}
