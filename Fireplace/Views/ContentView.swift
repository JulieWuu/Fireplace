//
//  ContentView.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            
            MainMenuView()
                .tabItem {
                    Label("Fireplace", systemImage: "fireplace")
                }
            
            TaskView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
