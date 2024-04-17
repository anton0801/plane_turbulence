//
//  StorePreviewView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI

struct StorePreviewView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: CollectionsView()
                        .environmentObject(preferences)
                        .navigationBarBackButtonHidden(true)) {
                            Image("ic_collections")
                        }
                }
                Image("ic_shop")
                    .offset(y: -40)
                
                Spacer()
                
                NavigationLink(destination: StoreView()
                    .navigationBarBackButtonHidden(true)) {
                        VStack {
                            Image("ic_imunity_big")
                            
                            Text("Immunity")
                                .font(.custom("ZenAntique-Regular", size: 32))
                                .foregroundColor(.white)
                        }
                    }
                
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    StorePreviewView()
}
