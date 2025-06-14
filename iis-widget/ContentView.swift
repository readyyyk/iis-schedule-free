//
//  ContentView.swift
//  iis-widget
//
//  Created by Vladislav Puzik on 14.06.2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        if userSettings.selectedGroupNumber == nil {
            GroupSelectionView()
        } else {
            MainScheduleView()
        }
    }
}

struct MainScheduleView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedDate: Date = Date()
    @State private var swipeOffset: CGFloat = 0
    @State private var swipeOpacity: Double = 1.0
    @State private var isAnimatingSwipe = false
    @State private var isCalendarPresented = false
    @State private var selectedSubgroup: Int = 0 // 0 = All, 1 = 1st, 2 = 2nd
    @State private var selectedLesson: Lesson? = nil
    @State private var isLessonSheetPresented: Bool = false
    // Persist selectedSubgroup in UserDefaults
    private let subgroupKey = "selectedSubgroup"
    
    private let lessonTypeColors: [String: Color] = [
        "ЛК": .green,
        "ЛР": .orange,
        "ПЗ": .red,
        "Консультация": .purple,
        "Экзамен": .red
    ]
    
    private func colorForLessonType(_ type: String?) -> Color {
        guard let type = type else { return .gray }
        return lessonTypeColors[type] ?? .gray
    }
    
    // Computed property for selected day's weekday (in Russian, as used by the API)
    private var selectedWeekday: String {
        weekdayName(selectedDate)
    }
    // Computed property for selected day's date string (localized)
    private var selectedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE – d MMMM yyyy"
        return dateFormatter.string(from: selectedDate).capitalized
    }
    // Computed property for lessons for selected day and current week
    private func lessons(for schedule: GroupSchedule, week: Int) -> [Lesson] {
        schedule.effectiveSchedules?[selectedWeekday]?.filter { lesson in
            let weekMatch = lesson.weekNumber?.contains(week) ?? false
            let subgroup = lesson.numSubgroup ?? 0
            let subgroupMatch = selectedSubgroup == 0 || subgroup == 0 || subgroup == selectedSubgroup
            return weekMatch && subgroupMatch
        } ?? []
    }
    
    private func animateSwipe(to direction: Int, completion: @escaping () -> Void) {
        guard !isAnimatingSwipe else { return }
        isAnimatingSwipe = true
        let duration = 0.10
        withAnimation(.easeInOut(duration: duration)) {
            swipeOffset = CGFloat(direction) * -80
            swipeOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
            swipeOffset = CGFloat(direction) * 80
            withAnimation(.easeInOut(duration: duration)) {
                swipeOffset = 0
                swipeOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                isAnimatingSwipe = false
            }
        }
    }
    
    private func goToPreviousDayAnimated() {
        animateSwipe(to: -1) {
            goToPreviousDay()
        }
    }
    private func goToNextDayAnimated() {
        animateSwipe(to: 1) {
            goToNextDay()
        }
    }
    private func goToTodayAnimated() {
        animateSwipe(to: 0) {
            goToToday()
        }
    }
    
    private func goToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }
    private func goToNextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }
    private func goToToday() {
        selectedDate = Date()
    }
    
    init() {
        if let saved = UserDefaults.standard.value(forKey: subgroupKey) as? Int {
            _selectedSubgroup = State(initialValue: saved)
        }
    }
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading schedule...")
                } else if let error = viewModel.error, !error.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()
                    }
                } else if let schedule = viewModel.schedule, let week = viewModel.currentWeek {
                    VStack(spacing: 8) {
                        // Subgroup filter picker
                        Picker("Subgroup", selection: Binding(
                            get: { selectedSubgroup },
                            set: { newValue in
                                selectedSubgroup = newValue
                                UserDefaults.standard.set(newValue, forKey: subgroupKey)
                            })
                        ) {
                            Text("All").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 4)
                        // Show selected date and weekday as a button
                        Button(action: { isCalendarPresented = true }) {
                            HStack(spacing: 6) {
                                Text(selectedDateString)
                                    .font(.headline)
                                Image(systemName: "calendar")
                                    .font(.subheadline)
                            }
                            .padding(.bottom, 2)
                        }
                        .buttonStyle(.plain)
                        if let start = schedule.startDate, let end = schedule.endDate {
                            Text("Schedule: \(start) – \(end)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        let lessons = lessons(for: schedule, week: week)
                        if lessons.isEmpty {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("No lessons for this day.")
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            Spacer()
                        } else {
                            List(lessons, id: \ .id) { lesson in
                                Button(action: {
                                    selectedLesson = lesson
                                    isLessonSheetPresented = true
                                }) {
                                    HStack(alignment: .center) {
                                        // Colored circle for lesson type
                                        Circle()
                                            .fill(colorForLessonType(lesson.lessonTypeAbbrev))
                                            .frame(width: 16, height: 16)
                                        VStack(alignment: .leading, spacing: 2) {
                                            if let time = lesson.startLessonTime, let end = lesson.endLessonTime {
                                                Text("\(time) - \(end)")
                                                    .font(.headline)
                                            }
                                            if let aud = lesson.auditories?.joined(separator: ", ") {
                                                Text(aud)
                                                    .font(.subheadline)
                                            }
                                        }
                                        Spacer()
                                        Text(lesson.subject ?? "Lesson")
                                            .font(.title3)
                                            .bold()
                                            .multilineTextAlignment(.trailing)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                            }
                            .offset(x: swipeOffset)
                            .opacity(swipeOpacity)
                        }
                    }
                    Spacer()
                    HStack {
                        Button(action: goToPreviousDayAnimated) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .padding()
                        }
                        Spacer()
                        Button(action: goToTodayAnimated) {
                            Text("Today")
                                .font(.headline)
                                .padding(.horizontal)
                        }
                        Spacer()
                        Button(action: goToNextDayAnimated) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                } else {
                    Text("No data available.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -40 {
                        goToNextDayAnimated()
                    } else if value.translation.width > 40 {
                        goToPreviousDayAnimated()
                    }
                }
        )
        .onAppear {
            if let groupNumber = userSettings.selectedGroupNumber, !groupNumber.isEmpty {
                print("[MainScheduleView] Loading schedule for groupNumber: \(groupNumber)")
                viewModel.loadSchedule(for: groupNumber)
            } else {
                print("[MainScheduleView] No group selected!")
            }
        }
        .navigationTitle("Schedule")
        .sheet(isPresented: $isCalendarPresented) {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
                Button("Done") {
                    isCalendarPresented = false
                }
                .padding(.bottom)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $isLessonSheetPresented) {
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson)
            }
        }
    }
}

// Helper to get weekday name in Russian (as used by the API)
private func weekdayName(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date).capitalized
}

#Preview {
    ContentView()
}

// MARK: - Lesson Detail View
struct LessonDetailView: View {
    let lesson: Lesson
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(lesson.subject ?? "Lesson")
                    .font(.title)
                    .bold()
                if let type = lesson.lessonTypeAbbrev {
                    Text("Type: \(type)")
                        .font(.headline)
                }
                if let time = lesson.startLessonTime, let end = lesson.endLessonTime {
                    Text("Time: \(time) - \(end)")
                }
                if let aud = lesson.auditories?.joined(separator: ", ") {
                    Text("Auditories: \(aud)")
                }
                if let employees = lesson.employees, !employees.isEmpty {
                    let names = employees.map(employeeName).joined(separator: ", ")
                    Text("Teachers: \(names)")
                }
                if let note = lesson.note, !note.isEmpty {
                    Text("Note: \(note)")
                }
                if let subgroup = lesson.numSubgroup {
                    Text("Subgroup: \(subgroup == 0 ? "Both" : String(subgroup))")
                }
                if let weeks = lesson.weekNumber {
                    Text("Weeks: \(weeks.map { String($0) }.joined(separator: ", "))")
                }
            }
            .padding()
        }
    }
}

// Helper to format employee name
private func employeeName(_ employee: Employee) -> String {
    let last = employee.lastName ?? ""
    let first = employee.firstName ?? ""
    let middle = employee.middleName ?? ""
    return ([last, first, middle].filter { !$0.isEmpty }).joined(separator: " ")
}
