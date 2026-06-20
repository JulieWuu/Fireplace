//
//  Task.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import Foundation
import SwiftData

@Model
class Task: Identifiable {
    
    @Attribute(.unique) private var name: String
    private var icon: String
    private var wood: Int
    var deleted: Bool = false
    
    init(name: String, icon: String, wood: Int) {
        self.name = name
        self.icon = icon
        self.wood = wood
        self.deleted = false
    }
    
    func setName(newName: String) {
        self.name = newName
    }
    
    func getName() -> String {
        return self.name
    }
    
    func setIcon(newIcon: String) {
        self.icon = newIcon
    }
    
    func getIcon() -> String {
        return self.icon
    }
    
    func setWood(newWood: Int) {
        self.wood = newWood
    }
    
    func getWood() -> Int {
        return self.wood
    }
    
}

