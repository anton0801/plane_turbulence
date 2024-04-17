//
//  RulesView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI
import AVFoundation

struct RulesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var currentPage = 0
    
    @State var player: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Image("ic_rules")
            
            Spacer()
            
            VStack {
                Text(rulesData[currentPage])
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
            
            Button {
                if currentPage < rulesData.count - 1 {
                    currentPage += 1
                }
            } label: {
                Image("ic_next")
            }
            
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
            if UserDefaults.standard.bool(forKey: "is_music_on") {
                playMusic()
            }
        }
        .onDisappear {
            if UserDefaults.standard.bool(forKey: "is_music_on") {
                self.player.pause()
                self.player.stop()
            }
        }
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "back", withExtension: "wav") else {
            return
        }

        self.player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        player.play()
    }
    
}

#Preview {
    RulesView()
}
