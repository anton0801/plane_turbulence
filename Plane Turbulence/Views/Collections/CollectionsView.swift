//
//  CollectionsView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI

struct CollectionsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var currentPage = 0
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                } label: {
                    Image("back_btn")
                }
                .disabled(currentPage == 0)
                .opacity(currentPage == 0 ? 0.6 : 1)
                
                Spacer()
                
                Button {
                    if currentPage < preferences.allCollections.count - 1 {
                        currentPage += 1
                    }
                } label: {
                    Image("forward_btn")
                }
                .disabled(currentPage == preferences.allCollections.count - 1)
                .opacity(currentPage < preferences.allCollections.count - 1 ? 1 : 0.6)
            }
            
            Spacer()
            
            VStack {
                ZStack {
                    Image(preferences.allCollections[currentPage])
                    if !preferences.unlockedCollections.contains(preferences.allCollections[currentPage]) {
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .frame(width: 214, height: 214)
                    }
                }
            }
            .background(
                Image("settings_back")
                    .resizable()
                    .frame(width: 340, height: 280)
            )
            
            Spacer()
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("home_btn")
            }
        }
        .background(
            Image("second_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    CollectionsView()
        .environmentObject(Preferences())
}
