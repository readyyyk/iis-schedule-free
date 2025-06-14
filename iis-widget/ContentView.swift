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
            lesson.weekNumber?.contains(week) ?? false
        } ?? []
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
    
    var body: some View {
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
                    // Show selected date and weekday
                    Text(selectedDateString)
                        .font(.headline)
                        .padding(.bottom, 2)
                    if let start = schedule.startDate, let end = schedule.endDate {
                        Text("Schedule: \(start) – \(end)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    let lessons = lessons(for: schedule, week: week)
                    if lessons.isEmpty {
                        Text("No lessons for this day.")
                            .foregroundColor(.secondary)
                    } else {
                        List(lessons, id: \ .id) { lesson in
                            VStack(alignment: .leading) {
                                Text(lesson.subject ?? "Lesson")
                                    .font(.headline)
                                if let time = lesson.startLessonTime, let end = lesson.endLessonTime {
                                    Text("\(time) - \(end)")
                                        .font(.subheadline)
                                }
                                if let aud = lesson.auditories?.joined(separator: ", ") {
                                    Text(aud)
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -40 {
                                goToNextDay()
                            } else if value.translation.width > 40 {
                                goToPreviousDay()
                            }
                        }
                )
                Spacer()
                HStack {
                    Button(action: goToPreviousDay) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding()
                    }
                    Spacer()
                    Button(action: goToToday) {
                        Text("Today")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    Spacer()
                    Button(action: goToNextDay) {
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
        .onAppear {
            if let groupNumber = userSettings.selectedGroupNumber, !groupNumber.isEmpty {
                print("[MainScheduleView] Loading schedule for groupNumber: \(groupNumber)")
                viewModel.loadSchedule(for: groupNumber)
            } else {
                print("[MainScheduleView] No group selected!")
            }
        }
        .navigationTitle("Schedule")
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
