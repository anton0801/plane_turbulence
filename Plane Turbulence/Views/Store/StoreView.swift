//
//  StoreView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI

struct StoreView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var preferences = Preferences()
    
    @State var buyAlert = false
    
    var body: some View {
        VStack {
            Image("ic_immunity")
            
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    Text("x\(preferences.immunityCount)")
                        .font(.custom("ZenAntique-Regular", size: 24))
                        .foregroundColor(.white)
                }
                .padding(.trailing, 52)
                Image("immunity")
                HStack {
                    Text("15")
                        .font(.custom("ZenAntique-Regular", size: 40))
                        .foregroundColor(.white)
                    Image("coin")
                }
            }
            .background(
                Image("store_item_back")
                    .resizable()
                    .frame(width: 350, height: 380)
            )
            
            Button {
                buyAlert = !preferences.buyImminity()
            } label: {
                Image("buy_btn")
            }
            
            Spacer()
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("back_btn")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        .background(
            Image("second_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $buyAlert) {
            Alert(title: Text("Buy error"),
            message: Text("You don't have enough coins to buy the invulnerability booster."),
                  dismissButton: .cancel(Text("Ok")))
        }
    }
}

#Preview {
    StoreView()
}
