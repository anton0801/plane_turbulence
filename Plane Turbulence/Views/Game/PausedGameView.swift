//
//  PausedGameView.swift
//  Plane Turbulence
//
//  Created by Anton on 17/4/24.
//

import SwiftUI

struct PausedGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @Binding var pausedGame: Bool
    
    var body: some View {
        VStack {
            Image("ic_pause_label")
            
            Spacer()
            
            VStack {
                Text("Game\nis\nhalted")
                    .textCase(.uppercase)
                    .font(.custom("ZenAntique-Regular", size: 35))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 220)
            .background(
                Image("settings_back")
                    .resizable()
                    .frame(width: 340, height: 280)
            )
            .zIndex(2)
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                }
                Button {
                    pausedGame = false
                } label: {
                    Image("ic_next")
                }
            }
            .zIndex(1)
            .offset(y: 10)
            
            Spacer()
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    PausedGameView(pausedGame: .constant(true))
}
