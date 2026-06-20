//
//  SettingsView.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            VStack {
                Text(" Well done, fireplace!")
                    .font(.custom("Komika Axis", size: 28))
                    .foregroundColor(.white)
                    
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
