//
//  TaskBundle.swift
//  Fireplace
//
//  Created by Julia Wu on 24/06/2026.
//

import Foundation
import SwiftData

@Model
class CompletionBundle: Identifiable {
    
    var date: Date
    private var taskCompletions: [TaskCompletion]
    private var totalWoods: Int
    
    init(date: Date, taskCompletions: [TaskCompletion]) {
        self.date = date
        self.taskCompletions = taskCompletions
        self.totalWoods = taskCompletions.reduce(0) { sum, completion in
            return sum + completion.getTask().getWood()
        }
    }
    
    func getTotalWoods() -> Int {
        return self.totalWoods
    }
    
    func addCompletion(_ completion: TaskCompletion) -> Void {
        self.taskCompletions.append(completion)
        self.totalWoods += completion.getTask().getWood()
    }
    
    func deleteCompletion(_ completion: TaskCompletion) -> Void {
        self.taskCompletions.removeAll(where: { $0.id == completion.id })
    }
    
    func deleteTas(_ task: Task) -> Void {
        self.taskCompletions.removeAll(where: { $0.getTask().getName() == task.getName() })
    }
}

