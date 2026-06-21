//
//  CalendarView.swift
//  Fireplace
//
//  Created by Julia Wu on 13/05/2026.
//


import SwiftUI
import SwiftData

// original code displaying each task completion
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
                    .taskItemStyle()
                }
                .scrollContentBackground(.hidden)
                    
            }
        }
    }
    
}*/

struct CalendarView: View {
    
    @State private var currentMonthDate = Date()
    @Query private var completedTasks: [TaskCompletion]
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let rowHeight: CGFloat = 50
    
    var body: some View {
        
        ZStack {
            Color("DefaultBG")
                .ignoresSafeArea(.all)
            
            LinearGradient(
                colors: [Color("DefaultBG"), Color("Overlay").opacity(1)],
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            VStack(spacing: 16) {
                
                // year
                HStack {
                    Button(action: { moveYear(by: -1) }) {
                        Image(systemName: "chevron.left.2")
                    }
                    .buttonStyle(.appButtonCustom(
                        backgroundColor: .white.opacity(0.1),
                        horizontalPadding: 15
                    ))
                    
                    Spacer()
                    
                    Text(formatYear(currentMonthDate))
                        .renogareText(size: 36)
                    
                    Spacer()
                    
                    Button(action: { moveYear(by: 1) }) {
                        Image(systemName: "chevron.right.2")
                    }
                    .buttonStyle(.appButtonCustom(
                        backgroundColor: .white.opacity(0.1),
                        horizontalPadding: 15
                    ))
                }
                .padding(.horizontal)
                
                // month
                HStack {
                    Button(action: { moveMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.appButtonCustom(
                        backgroundColor: .white.opacity(0.1),
                        horizontalPadding: 15
                    ))
                    
                    Spacer()
                    
                    Text(formatMonth(currentMonthDate))
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
                .padding(.bottom, 10)
                
                // grid headings
                HStack(spacing: 0) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .appContentStyle(size: 16, weight: .bold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // grid of dates
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(selectedMonthDates) { day in
                        CalendarDayCell(day: day, isToday: false, height: rowHeight)
                            .padding(1)
                    }
                }
                .padding(.horizontal)
                
                // tasks completions list
                VStack(spacing: 0) {
                    HStack {
                        Text("Tasks completed: ")
                            .renogareText(size: 18)
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    List {
                        ForEach(completedTasks) { taskCompletion in
                            let task = taskCompletion.getTask()
                            Text("Completed: \(task.getName()) at \(taskCompletion.getCompletionTime())")
                                .appContentStyle()
                        }.taskItemStyle()
                    }
                    .taskListStyle()
                }
            }
        }
        .background(Color("DefaultBG").ignoresSafeArea(.all))
    }
    
    var selectedMonthDates: [Day] {
        return extractMonthDates(currentMonthDate)
    }
    
    private func extractMonthDates(_ month: Date) -> [Day] {
        var days: [Day] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        // locate first day in the month
        let components = calendar.dateComponents([.year, .month], from: month)
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return days
        }
        
        // repeatedly adding (number of days) in the month to the first day
        guard let range = calendar.range(of: .day, in: .month, for: month)?.compactMap({
            value -> Date? in
            return calendar.date(byAdding: .day, value: value - 1, to: firstDayOfMonth)
        })
        else {
            return days
        }
        
        // locate first weekday of the month to add excess days of previous month
        let firstWeekDay = calendar.component(.weekday, from: range.first!)
        for index in Array(0..<firstWeekDay - 1).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -index - 1, to: range.first!) else { return days }
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
        }
        
        range.forEach { date in
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date))
        }
        
        // locate last weekday of the month to add excess days of next month
        let lastWeekDay = 7 - calendar.component(.weekday, from: range.last!)
        if lastWeekDay > 0 {
            for index in 0..<lastWeekDay {
                guard let date = calendar.date(byAdding: .day, value: index + 1, to: range.last!) else { return days }
                let shortSymbol = formatter.string(from: date)
                days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
            }
        }
        
        return days
    }
    
    private func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonthDate) {
            currentMonthDate = newDate
        }
    }
    
    private func moveYear(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .year, value: value, to: currentMonthDate) {
            currentMonthDate = newDate
        }
    }
    
    private func formatYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
}

struct CalendarDayCell: View {
    let day: Day
    let isToday: Bool
    let height: CGFloat
    
    var totalWoodCollected: Int {
        if day.shortSymbol == "06" { return 14 }
        if day.shortSymbol == "15" { return 6 }
        return 0
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text(day.shortSymbol)
                    .appContentStyle(color: day.ignored ? .gray : .white)
                    .padding(.top, 4)
                Spacer()
            }
            
            if totalWoodCollected > 0 {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Text("🔥")
                        .appContentStyle(size: 16)
                        .padding(.bottom, 4)
                    
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
        }
        .frame(height: height)
        .cornerRadius(10)
    }
}

struct Day: Identifiable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    var ignored: Bool = false
}

#Preview {
    CalendarView()
        .modelContainer(for: [Task.self, TaskCompletion.self])
}
