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
    
    @State private var vm = BagViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if bag.clubs.isEmpty {
                    Text("No clubs currently in bag")
                    Text("Click the + in the top right corner to add a club")
                } else {
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
                                vm.deleteClub(club, from: bag)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bag")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        vm.isShowingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: $vm.isShowingSheet, onDismiss: {
                vm.isShowingSheet = false
            }, content: {
//                @Bindable var bag = bag
                AddClubView(isShowing: $vm.isShowingSheet)
            })
        }
    }
}

#Preview {
    BagView()
        .environment(Bag(clubs: Bag.examples))
}
