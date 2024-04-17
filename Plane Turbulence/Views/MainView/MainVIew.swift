//
//  MainVIew.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI
import AVFoundation

struct MainVIew: View {
    
    @State var player: AVAudioPlayer!
    
    @State var preferences = Preferences()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true)) {
                        Image("settings_btn")
                    }
                    Spacer()
                    NavigationLink(destination: RulesView().navigationBarBackButtonHidden(true)) {
                        Image("ic_info")
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: LevelsView()
                    .environmentObject(preferences)
                    .navigationBarBackButtonHidden(true)) {
                    Image("play_btn")
                }
                
                Button {
                    exit(0)
                } label: {
                    Image("exit_btn")
                        .padding(.top)
                }
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: StorePreviewView()
                        .environmentObject(preferences)
                        .navigationBarBackButtonHidden(true)) {
                        Image("ic_store")
                    }
                    Spacer()
                }
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                createLevels()
                setDataAsFirstLaunch()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "back", withExtension: "wav") else {
            return
        }

        self.player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        player.play()
    }
    
    func setDataAsFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: "is_not_first_launch") {
            UserDefaults.standard.set(true, forKey: "is_music_on")
            UserDefaults.standard.set(true, forKey: "is_sounds_on")
            UserDefaults.standard.set("level_1,", forKey: "unlocked_levels")
            UserDefaults.standard.set(true, forKey: "is_not_first_launch")
        }
    }
    
}

#Preview {
    MainVIew()
}
