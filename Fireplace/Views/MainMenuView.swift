//
//  MainMenu.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Welcome, fireplace!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.white))
            }
            
        }
    }
}

#Preview {
    ContentView()
}
