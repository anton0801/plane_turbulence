//
//  SettingsView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var musicOn = true
    @State var soundsOn = true
    
    var body: some View {
        VStack {
            Image("adjustment")
            
            Spacer()
            
            VStack {
                VStack {
                    Text("MUSIC")
                        .font(.custom("ZenAntique-Regular", size: 24))
                        .foregroundColor(.white)
                    
                    HStack {
                        Button {
                            musicOn = false
                        } label: {
                            if musicOn {
                                Image("no_disactive")
                            } else {
                                Image("no_active")
                            }
                        }
                        Button {
                            musicOn = true
                        } label: {
                            if musicOn {
                                Image("yes_active")
                            } else {
                                Image("yes_disactive")
                            }
                        }
                    }
                    .frame(width: 80, height: 20)
                }
                .offset(y: -15)
                
                VStack {
                    Text("Sounds")
                        .font(.custom("ZenAntique-Regular", size: 24))
                        .foregroundColor(.white)
                    HStack {
                        Button {
                            soundsOn = false
                        } label: {
                            if soundsOn {
                                Image("no_disactive")
                            } else {
                                Image("no_active")
                            }
                        }
                        Button {
                            soundsOn = true
                        } label: {
                            if soundsOn {
                                Image("yes_active")
                            } else {
                                Image("yes_disactive")
                            }
                        }
                    }
                    .frame(width: 80, height: 20)
                }
                .offset(y: -10)
            }
            .frame(height: 220)
            .background(Image("settings_back"))
            
            Button {
                UserDefaults.standard.set(musicOn, forKey: "is_music_on")
                UserDefaults.standard.set(soundsOn, forKey: "is_sounds_on")
                presMode.wrappedValue.dismiss()
            } label: {
                Image("settings_done")
            }
            .offset(y: -25)
            
            Spacer()
        }
        .onAppear {
            musicOn = UserDefaults.standard.bool(forKey: "is_music_on")
            soundsOn = UserDefaults.standard.bool(forKey: "is_sounds_on")
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
    SettingsView()
}
