//
//  LevelsView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI

struct LevelsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var currentPage = 0
    @State var levelsData = [Level]()
    
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        if currentPage > 0 {
                            currentPage -= 1
                            divideLevelsDataPerPage()
                        }
                    } label: {
                        Image("back_btn")
                    }
                    .disabled(currentPage == 0)
                    .opacity(currentPage == 0 ? 0.6 : 1)
                    
                    Spacer()
                    
                    Button {
                        if currentPage < 1 {
                            currentPage += 1
                            divideLevelsDataPerPage()
                        }
                    } label: {
                        Image("forward_btn")
                    }
                    .disabled(currentPage == 1)
                    .opacity(currentPage == 1 ? 0.6 : 1)
                }
                Image("ic_levels")
                    .offset(y: -50)
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 120)),
                    GridItem(.flexible(minimum: 120)),
                    GridItem(.flexible(minimum: 120))
                ], spacing: 16) {
                    ForEach(levelsData, id: \.name) { levelItem in
                        if preferences.unlockedLevels.contains(levelItem.name) {
                            NavigationLink(destination: GameView(level: levelItem)
                                .environmentObject(preferences)
                                .navigationBarBackButtonHidden(true)) {
                                    ZStack {
                                        Image("level_bg")
                                        Text("\(levelItem.level)")
                                            .font(.custom("ZenAntique-Regular", size: 52))
                                            .foregroundColor(.white)
                                    }
                                }
                        } else {
                            ZStack {
                                Image("levels_bg_disabled")
                                Text("\(levelItem.level)")
                                    .font(.custom("ZenAntique-Regular", size: 52))
                                    .foregroundColor(.white)
                                    .opacity(0.6)
                            }
                        }
      
                    }
                }
                .offset(y: -30)
                
                Spacer()
                
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                }
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                if levels.isEmpty {
                    createLevels()
                }
                self.levelsData = levels
                divideLevelsDataPerPage()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func divideLevelsDataPerPage() {
        let chunks = splitArrayIntoChunks(levels, chunkSize: 12)
        let levelsDataInPage = chunks[currentPage]
        self.levelsData = levelsDataInPage
    }
    
    func splitArrayIntoChunks<T>(_ array: [T], chunkSize: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0 ..< Swift.min($0 + chunkSize, array.count)])
        }
    }
    
}

#Preview {
    LevelsView()
        .environmentObject(Preferences())
}
