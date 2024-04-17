//
//  GameLoseView.swift
//  Plane Turbulence
//
//  Created by Anton on 17/4/24.
//

import SwiftUI

struct GameLoseView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @Binding var restartGame: Bool
    
    var body: some View {
        VStack {
            Image("ic_lose_label")
            
            Spacer()
            
            VStack {
                Text("You've lost, don't get upset and try again.")
                    .textCase(.uppercase)
                    .font(.custom("ZenAntique-Regular", size: 26))
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
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                Button {
                    restartGame = true
                } label: {
                    Image("ic_restart")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
            .zIndex(1)
            .offset(y: 25)
            
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
    GameLoseView(restartGame: .constant(false))
}
