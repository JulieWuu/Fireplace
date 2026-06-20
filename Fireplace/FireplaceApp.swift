//
//  FireplaceApp.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import SwiftUI
import SwiftData

@main
struct FireplaceApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Task.self, TaskCompletion.self])
    }
}
