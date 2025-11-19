//
//  RoundView.swift
//  GolfCompanion
//
//  Created by Rafe Marriott on 16/09/2025.
//

import SwiftUI

struct RoundView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CoursesViewModel.self) private var vm
    
    @Binding var course: Course
    @Binding var tee: Tee
    @Binding var roundScores: [Int]
    @Binding var showingRoundSummary: Bool
    
    @State private var holeNumber: Int = 1
    @State private var showingAlert: Bool = false
    @State private var pendingScore: Int?
    @State private var totalScore: Int = 0
    @State private var showScorecard: Bool = false
    @State private var showCaddy: Bool = false
    @State var showingCaddyAlert: Bool = false
    @State var recommendedClub: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    Text("Distance: \(tee.holes[holeNumber - 1].yardage) yds")
                    Text("Par: \(tee.holes[holeNumber - 1].par)")
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            showCaddy = true
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
            
            VStack(alignment: .leading) {
                Text("Score")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        pendingScore = 1
                        showingAlert = true
                    }, label: {
                        Image(systemName: "1.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 2
                        showingAlert = true
                    }, label: {
                        Image(systemName: "2.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 3
                        showingAlert = true
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
                        pendingScore = 4
                        showingAlert = true
                    }, label: {
                        Image(systemName: "4.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 5
                        showingAlert = true
                    }, label: {
                        Image(systemName: "5.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 6
                        showingAlert = true
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
                        pendingScore = 7
                        showingAlert = true
                    }, label: {
                        Image(systemName: "7.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 8
                        showingAlert = true
                    }, label: {
                        Image(systemName: "8.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pendingScore = 9
                        showingAlert = true
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
                Text("Hole \(holeNumber)")
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
                    showScorecard = true
                }, label: {
                    Image(systemName: "list.dash")
                })
            }
        }
        .alert("Add score of \(pendingScore ?? 0)", isPresented: $showingAlert, presenting: pendingScore) { score in
            Button("Add") {
                roundScores.append(score)
                totalScore += score
                
                if holeNumber >= tee.holes.count {
                    pendingScore = nil
                    
                    vm.scoresList.append(CourseIDScore(score: totalScore, courseId: course.courseId, date: Date.now, teeName: tee.teeName))
                    
                    showingRoundSummary = true
                    dismiss()
                } else {
                    holeNumber += 1
                    pendingScore = nil
                }
            }
            
            Button("Cancel", role: .cancel) {
                pendingScore = nil
            }
        } message: { score in
            Text("Record \(score) for hole \(holeNumber)?")
        }
        .navigationDestination(isPresented: $showScorecard) {
            Scorecard_View(tee: $tee, scores: $roundScores)
        }
        .sheet(isPresented: $showCaddy) {
            CaddyView(clubToHit: $recommendedClub, showingAlert: $showingCaddyAlert)
        }
        .alert("Recommended club: \(recommendedClub)", isPresented: $showingCaddyAlert, presenting: recommendedClub) {_ in 
            Button("OK", role: .cancel) {}
        }
    }
}

//#Preview {
//    RoundView()
//}
