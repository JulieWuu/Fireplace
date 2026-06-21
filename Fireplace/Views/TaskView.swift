//
//  TaskView.swift
//  Fireplace
//
//  Created by Julia Wu on 06/05/2026.
//


import SwiftUI
import SwiftData

enum TaskFormMode: Identifiable {
    case add
    case edit(Task)
    
    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let task): return "edit-\(task.getName())"
        }
    }
}

struct TaskView: View {
    
    @Query(filter: #Predicate<Task> {!$0.deleted}) private var activeTasks: [Task]
    @Query(filter: #Predicate<Task> {$0.deleted}) private var deletedTasks: [Task]
    @Query(sort: \TaskCompletion.completionTime, order: .reverse)
    private var taskCompletions: [TaskCompletion]
    @Environment(\.modelContext) private var modelContext
    
    @State private var activeFormMode: TaskFormMode? = nil
    @State private var showDeletedTasks: Bool = false
    @State private var taskToPermanentlyDelete: Task? = nil
    @State private var taskToEdit: Task? = nil
    @State private var newTaskName: String = ""
    @State private var newTaskWood: String = ""
    @State private var newTaskIcon: String = ""
    
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            Image("CartoonFire")
                .resizable()
                .scaledToFit()
                .offset(y: 30)
                .opacity(0.2)

            List {
                Section() {
                    ZStack {
                        Text(" All Tasks ").renogareText(size: 30)
                        
                        HStack {
                            Spacer()
                            Button("+") {
                                activeFormMode = .add
                            }
                            .buttonStyle(.appButtonCustom(verticalPadding: 5, horizontalPadding: 12))
                            .padding(EdgeInsets(top: 5, leading: 15,
                                                bottom: 0, trailing: 15))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0,
                                        bottom: 20, trailing: 0))
                    
                    ForEach(activeTasks) { task in
                        HStack {
                            Text(" \(task.getIcon()) ").appContentStyle()
                            
                            Spacer().frame(width: 15)
                            
                            Text(" \(task.getName()) ").appContentStyle()
                            
                            Spacer()
                            Spacer().frame(width: 10)
                            
                            Text("\(task.getWood()) 🪵").appContentStyle(weight: .bold)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteTask(task: task)
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button {
                                activeFormMode = .edit(task)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                    .taskItemStyle()
                }
                .listRowBackground(Color.clear)
                
                Section() {
                    Button {
                        showDeletedTasks.toggle()
                    } label: {
                        HStack {
                            Text(" Deleted Tasks ").renogareText(size: 20)
                            
                            Spacer()
                                .frame(width: 5)
                            
                            Image(systemName:
                                    showDeletedTasks
                                    ? "chevron.down"
                                    : "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if showDeletedTasks {
                        
                        ForEach(deletedTasks) { task in
                            HStack {
                                Text(" \(task.getIcon()) ").appContentStyle()
                                
                                Spacer().frame(width: 15)
                                
                                Text(" \(task.getName()) ").appContentStyle()
                                
                                Spacer()
                                Spacer().frame(width: 10)
                                
                                Text("\(task.getWood()) 🪵").appContentStyle(weight: .bold)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    taskToPermanentlyDelete = task
                                } label: {
                                    Image(systemName: "trash")
                                }
                                
                                Button {
                                    recoverTask(task: task)
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                }
                                .tint(.green)
                            }
                        }.taskItemStyle()
                    }
                    
                }
                .listRowBackground(Color.clear)
                
            }
            .taskListStyle()
            .sheet(item: $taskToEdit) { task in
                AddTaskView(taskToEdit: task)
            }
            
            if let task = taskToPermanentlyDelete {
                Color.black.opacity(0.4)
                    .ignoresSafeArea() // Dims the background
                
                VStack(spacing: 20) {
                    Text("WARNING").renogareText(size: 24, color: .red)
                    
                    Text(" Are you sure you want to delete '\(task.getName())'? All '\(task.getName())' task completions and woods collected from them will be permanently deleted at the same time. ").appContentStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 30) {
                        Button(" Cancel ") {
                            taskToPermanentlyDelete = nil
                        }
                        .buttonStyle(.appBasic)
                        
                        Button(" Delete ") {
                            permanentDelete(task: task)
                            taskToPermanentlyDelete = nil
                        }
                        .buttonStyle(.appDestructive)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
                .background(Color("Overlay").opacity(100))
                .cornerRadius(20)
                .padding(40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sheet(item: $activeFormMode) { mode in
            switch mode {
            case .add:
                AddTaskView(taskToEdit: nil)
                    .presentationDetents([.large, .medium, .fraction(0.85)])
                    .presentationBackground(Color("Overlay"))
            case .edit(let task):
                AddTaskView(taskToEdit: task)
                    .presentationDetents([.large, .medium, .fraction(0.85)])
                    .presentationBackground(Color("Overlay"))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: taskToPermanentlyDelete)
    }
    
    func deleteTask(task: Task) {
        task.deleted = true
    }
    func recoverTask(task: Task) {
        task.deleted = false
    }
    
    func permanentDelete(task: Task) {
        let completionsToDelete = taskCompletions.filter {
            $0.getTask() == task
        }
        for completion in completionsToDelete {
            modelContext.delete(completion)
        }
        modelContext.delete(task)
    }
    
}

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var taskToEdit: Task? = nil
    
    @State private var newTaskName: String = ""
    @State private var newTaskWood: String = ""
    @State private var newTaskIcon: String = "🔥"
    
    private var isEditing: Bool {
            taskToEdit != nil
        }
    
    let emojis: [String] = ["🔥", "💧", "💬", "⭐", "⏰", "📅",
                            "❤️", "🩷", "🧡", "💚", "💙", "🩵",
                            "📖", "📕", "📘", "📗", "📙", "📚",
                            "✏️", "✒️", "🛠️", "⚙️", "🔒", "💰",
                            "🎹", "🎶", "🎻", "🥁", "🎸", "🎷",
                            "💪🏼", "⚽", "🎾", "🏀", "🎱", "🩱",
                            "🎮", "🃏", "🀄", "🎭", "🧩", "🎲",
                            "💊", "🧪", "📐", "🔬", "🔭", "🩺",
    ]
    
    var body: some View {
        VStack {
            Text(isEditing ? "Edit Task" : "Create new task")
                .renogareText(size: 26)
                .padding(EdgeInsets(top: 50, leading: 20,
                                    bottom: 20, trailing: 20))
            
            VStack {
                HStack {
                    Text(newTaskIcon)
                        .font(.title)
                        .frame(alignment: .center)
                        .padding(.leading, 20)
                    
                    Spacer().frame(width: 20)
                    
                    TextField(
                        text: $newTaskName,
                        prompt: Text("New Task Name")
                            .foregroundColor(.white.opacity(0.6))
                    ) {
                        Text("New Task Name").appContentStyle()
                    }
                    .appTextFieldStyle()
                    .padding(.trailing, 20)
                }
                
                HStack {
                    Text("How many 🪵 is it worth?")
                        .appContentStyle()
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    TextField(
                        text: $newTaskWood,
                        prompt: Text("1").foregroundColor(.white.opacity(0.6))
                    ) {
                        Text("1").appContentStyle()
                    }
                        .appTextFieldStyle()
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                        .keyboardType(.numberPad)
                        .padding(.trailing, 20)
                }
                
                HStack {
                    Text("Choose an icon!")
                        .appContentStyle()
                        .padding(EdgeInsets(top: 0, leading: 20,
                                            bottom: 0, trailing: 20))
                    Spacer()
                }
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(emojis, id: \.self) {
                            emoji in Text(emoji)
                                .font(.title)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white.opacity(0.8), lineWidth: 1))
                                .frame(height: 50)
                                .onTapGesture {
                                    newTaskIcon = emoji
                                }
                        }
                    }
                    .padding(10)
                    .background(.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                
            }
            
            Button(isEditing ? "Save Changes" : "Add") {
                saveTask()
                dismiss()
            }
            .buttonStyle(.appButtonCustom(textSize: 20))
            .disabled(newTaskName.isEmpty || newTaskWood.isEmpty)
            
        }
        .onAppear {
            if let task = taskToEdit {
                newTaskName = task.getName()
                newTaskWood = String(task.getWood())
                newTaskIcon = task.getIcon()
            }
        }
    }
    
    private func saveTask() {
        if let newTaskWoodInt = Int(newTaskWood) {
            if let task = taskToEdit {
                task.setName(newName: newTaskName)
                task.setWood(newWood: newTaskWoodInt)
                task.setIcon(newIcon: newTaskIcon)
            }
            else {
                let newTask = Task(name: newTaskName, icon: newTaskIcon, wood: newTaskWoodInt)
                modelContext.insert(newTask)
            }
            
            newTaskName = ""
            newTaskWood = ""
        }
        
    }
}

#Preview {
    TaskView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
