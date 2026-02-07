//
//  RoundView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 16/09/2025.
//

import SwiftUI

struct RoundView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CoursesViewModel.self) private var coursesVm
    
    @Binding var course: Course
    @Binding var tee: Tee
    @Binding var roundScores: [Int]
    @Binding var showingRoundSummary: Bool
    @Binding var showingRoundView: Bool
    
    @State private var vm = RoundViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                // hole details
                Section {
                    Text("Distance: \(tee.holes[vm.holeNumber - 1].yardage) yds")
                    Text("Par: \(tee.holes[vm.holeNumber - 1].par)")
                }
                
                // caddy button
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            vm.showCaddy = true
                        } label: {
                            Text("Caddy")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .frame(minWidth: 150, minHeight: 70)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets())
                        
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            // score buttons
            VStack(alignment: .leading) {
                Text("Score")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        vm.pendingScore = 1
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "1.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 2
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "2.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 3
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "3.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        vm.pendingScore = 4
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "4.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 5
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "5.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 6
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "6.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        vm.pendingScore = 7
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "7.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 8
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "8.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        vm.pendingScore = 9
                        vm.showingAlert = true
                    }, label: {
                        Image(systemName: "9.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                }
            }
            .frame(height: 350)
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .background(Color(UIColor.systemGroupedBackground))
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("Hole \(vm.holeNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            })
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    roundScores = []
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Cancel")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    vm.showScorecard = true
                }, label: {
                    Image(systemName: "list.dash")
                })
            }
        }
        .alert("Add score of \(vm.pendingScore ?? 0)", isPresented: $vm.showingAlert, presenting: vm.pendingScore) { score in
            Button("Add") {
                vm.addScore(coursesVm, score, $roundScores, $tee, $course, $showingRoundSummary, $showingRoundView)
            }
            
            Button("Cancel", role: .cancel) {
                vm.pendingScore = nil
            }
        } message: { score in
            Text("Record \(score) for hole \(vm.holeNumber)?")
        }
        .navigationDestination(isPresented: $vm.showScorecard) {
            Scorecard_View(tee: $tee, scores: $roundScores)
        }
        .sheet(isPresented: $vm.showCaddy) {
            CaddyView(clubToHit: $vm.recommendedClub, showingAlert: $vm.showingCaddyAlert)
        }
        .alert("Recommended club: \(vm.recommendedClub)", isPresented: $vm.showingCaddyAlert, presenting: vm.recommendedClub) {_ in
            Button("OK", role: .cancel) {}
        }
    }
}
