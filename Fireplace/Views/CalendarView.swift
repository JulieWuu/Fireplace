//
//  CalendarView.swift
//  Fireplace
//
//  Created by Julia Wu on 13/05/2026.
//


import SwiftUI
import SwiftData
/*
struct CalendarView: View {
    
    @Query private var completedTasks: [TaskCompletion]
    
    var body: some View {
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            VStack {
                Text(" Calendar ")
                    .renogareText(size: 36)
                    .padding(.top)
                
                List {
                    ForEach(completedTasks) { taskCompletion in
                        let task = taskCompletion.getTask()
                        Text("Completed: \(task.getName()) at \(taskCompletion.getCompletionTime())")
                            .appContentStyle()
                    }
                    .taskListStyle()
                }
                .scrollContentBackground(.hidden)
                    
            }
        }
    }
    
}*/

struct CalendarView: View {
    
    @State private var currentMonthDate = Date()
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Calendar")
                .renogareText(size: 36)
                .padding(.bottom, 10)
            
            HStack {
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.appButtonCustom(
                    backgroundColor: .white.opacity(0.1),
                    horizontalPadding: 15
                ))
                
                Spacer()
                
                Text(formatMonthYear(currentMonthDate))
                    .renogareText(size: 24)
                
                Spacer()
                
                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.appButtonCustom(
                    backgroundColor: .white.opacity(0.1),
                    horizontalPadding: 15
                ))
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .appContentStyle(size: 14, weight: .bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<getStartingSpaces(), id: \.self) { _ in
                    Color.clear
                        .frame(height: 80)
                }
                
                ForEach(1...getDaysInMonth(), id: \.self) { dayNumber in
                    let cellDate = generateDate(for: dayNumber)
                    
                    CalendarDayCell(
                        dayNumber: dayNumber,
                        date: cellDate,
                        // TODO: fix isToday logic
                        isToday: false
                    )
                }
                .padding(.vertical, 1)
                .padding(.horizontal, 1)
            }
            .padding(.horizontal)
            
            Spacer()
            
        }
        .background(Color("DefaultBG").ignoresSafeArea())
    }
    
    // --- 🔑 DATABASE & MATHEMATICS LOGIC HELPER FUNCTIONS ---
    
    private func getDaysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: currentMonthDate)!
        return range.count
    }
    
    private func getStartingSpaces() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonthDate)
        let firstOfMonth = Calendar.current.date(from: components)!
        let weekday = Calendar.current.component(.weekday, from: firstOfMonth)
        return weekday - 1 // Returns how many blank slots we need before Day 1
    }
    
    private func generateDate(for day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: currentMonthDate)
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonthDate) {
            currentMonthDate = newDate
        }
    }
    
    private func formatMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarDayCell: View {
    let dayNumber: Int
    let date: Date
    let isToday: Bool
    
    var totalWoodCollected: Int {
        if dayNumber == 12 { return 14 }
        if dayNumber == 15 { return 6 }
        return 0
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if isToday {
                Color.blue.opacity(0.4)
            }
            else {
                Color.gray.opacity(0.3)
            }
            
            Text("\(dayNumber)")
                .appContentStyle(size: 14, weight: .bold)
                .padding(.top, 4)
            
            if totalWoodCollected > 0 {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Text("🔥")
                        .appContentStyle(size: 16)
                        .padding(.bottom, 4)
                    
                    Text("\(totalWoodCollected) 🪵")
                        .appContentStyle(size: 12, weight: .bold, color: .brown)
                        .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
        }
        .frame(height: 80)
        .cornerRadius(10)
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
