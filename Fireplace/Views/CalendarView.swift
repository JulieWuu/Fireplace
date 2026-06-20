//
//  CalendarView.swift
//  Fireplace
//
//  Created by Julia Wu on 13/05/2026.
//


import SwiftUI
import SwiftData

struct CalendarView: View {
    
    @Query private var completedTasks: [TaskCompletion]
    
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            VStack {
                Text(" Calendar ")
                    .font(.custom("Komika Axis", size: 36))
                    .foregroundColor(.white)
                    .padding(.bottom)
                
                List {
                    ForEach(completedTasks) { taskCompletion in
                        let task = taskCompletion.getTask()
                        Text("Completed: \(task.getName()) at \(taskCompletion.getCompletionTime())")
                            .foregroundColor(.black)
                    }
                    .listSectionSeparator(.hidden)
                    .listRowBackground(Capsule()
                        .fill(Color.white.opacity(0.6))
                        .padding(3))
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 40,
                                                   bottom: 0, trailing: 40))
                }
                .scrollContentBackground(.hidden)
                
                
                    
            }
        }
    }
    
}

#Preview {
    CalendarView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
