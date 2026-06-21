//
//  MainMenu.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \TaskCompletion.completionTime, order: .reverse)
    private var taskCompletions: [TaskCompletion]
    
    @State private var showClaimWoodsSheet: Bool = false
    @State private var showTodaysTasksSheet: Bool = false

    var todaysCompletions: [TaskCompletion] {
        let start = Calendar.current.startOfCustomDay()
        return taskCompletions.filter {
            $0.getCompletionTime() >= start
        }
    }
    
    var currentWoods: Int {
        todaysCompletions.reduce(0) {
            $0 + $1.getTask().getWood()
        }
    }
    
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            Image("CartoonFire")
                .resizable()
                .scaledToFit()
                .offset(y: 30)
            
            VStack {
                VStack {
                    Text(" You have collected ").renogareText(size: 28)
                    Text(" \(currentWoods) ").renogareText(size: 56)
                    Text(" woods today ").renogareText(size: 28)
                    Spacer()
                }
                .padding(.top, 50)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Completions", systemImage: "checkmark.seal.fill") {
                        showTodaysTasksSheet.toggle()
                    }
                    .buttonStyle(.appButtonCustom(backgroundColor: .blue))
                    .padding(.vertical, 30)
                    
                    Spacer()
                    
                    Button("Claim Woods", systemImage: "flame.fill") {
                        showClaimWoodsSheet.toggle()
                    }
                    .buttonStyle(.appButtonCustom(backgroundColor: .orange))
                    .padding(.vertical, 30)
                    
                    Spacer()
                }
            }
            
        }
        .sheet(isPresented: $showTodaysTasksSheet) {
            TodaysTaskView(
                todaysCompletions: todaysCompletions,
                onClaimWoodsTap: {
                    showTodaysTasksSheet = false
                    showClaimWoodsSheet = true
                }
            )
            .presentationDetents([.medium, .large, .fraction(0.85)])
            .presentationBackground(Color("DefaultBG"))
        }
        .sheet(isPresented: $showClaimWoodsSheet) {
            ClaimWoodsView(
                onDismissAction: {
                    showTodaysTasksSheet = true
                }
            )
            .presentationDetents([.large, .medium, .fraction(0.85)])
            .presentationBackground(Color("DefaultBG"))
        }
    }
}

struct TodaysTaskView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var todaysCompletions: [TaskCompletion]
    var onClaimWoodsTap: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Text(" Tasks completed today ")
                    .renogareText(size: 24)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(todaysCompletions) { taskCompletion in
                        HStack {
                            let task = taskCompletion.getTask()
                            
                            Text(" \(task.getIcon()) ")
                            
                            Text(" \(task.getName()) ").appContentStyle()
                            
                            Spacer()
                            Spacer().frame(width: 10)
                            
                            Text("\(task.getWood()) 🪵")
                                .appContentStyle(weight: .bold)
                            
                            Text(taskCompletion.getCompletionTime(), style: .time)
                                .appContentStyle()
                                .frame(width: 60)
                        }
                        .taskItemStyle()
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteTaskCompletion(taskCompletion: taskCompletion)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .taskListStyle()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button("Claim Woods", systemImage: "flame.fill") {
                        onClaimWoodsTap()
                    }
                    .buttonStyle(.appButtonCustom(backgroundColor: .orange))
                    .padding(.horizontal)
                }
            }
        }
    }
    
    func deleteTaskCompletion(taskCompletion: TaskCompletion) {
        modelContext.delete(taskCompletion)
    }
}

struct ClaimWoodsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Task> {!$0.deleted}) private var tasks: [Task]
    @Query private var taskCompletions: [TaskCompletion]
    
    var onDismissAction: () -> Void
    
    var body: some View {
        VStack {
            Text(" All tasks ").renogareText(size: 30)
                .padding(.top, 50)
            
            List {
                ForEach(tasks) { task in
                    HStack {
                        Button {
                            modelContext.insert(TaskCompletion(task: task, completionTime: Date()))
                            
                            dismiss()
                            onDismissAction()
                        } label: {
                            HStack {
                                Text("\(task.getIcon())  \(task.getName())").appContentStyle()
                                Spacer()
                                Text("🪵 × \(task.getWood())")
                                    .appContentStyle(weight: .bold)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }.taskItemStyle()
            }
            .taskListStyle()
        }
    }
}

#Preview {
    MainMenuView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
