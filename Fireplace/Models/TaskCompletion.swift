//
//  TaskCompletion.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import Foundation
import SwiftData

@Model
class TaskCompletion: Identifiable {
    
    private final var task: Task
    var completionTime: Date
    
    init(task: Task, completionTime: Date) {
        self.task = task
        self.completionTime = completionTime
    }
    
    func getTask() -> Task {
        return self.task
    }
    
    func getCompletionTime() -> Date {
        return self.completionTime
    }
    
}
