import WidgetKit
import SwiftUI
import Foundation

let appGroupID = "group.todooos.inc.iis-widget"

struct LessonEntry: TimelineEntry {
    let date: Date
    let lessons: [Lesson]
}

struct ScheduleTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> LessonEntry {
        LessonEntry(date: Date(), lessons: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (LessonEntry) -> ()) {
        let entry = LessonEntry(date: Date(), lessons: loadTodaysLessons())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LessonEntry>) -> ()) {
        let entry = LessonEntry(date: Date(), lessons: loadTodaysLessons())
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    func loadTodaysLessons() -> [Lesson] {
        print("[Widget] loadTodaysLessons called")
        let userDefaults = UserDefaults(suiteName: appGroupID)
        let keys = userDefaults?.dictionaryRepresentation().keys.map { String($0) } ?? []
        print("[Widget] App Group keys: \(keys)")
        guard let data = userDefaults?.data(forKey: "cachedGroupSchedule"),
              let schedule = try? JSONDecoder().decode(GroupSchedule.self, from: data) else {
            print("[Widget] No schedule data found in App Group.")
            return []
        }
        // For testing: always use June 7, 2025 as 'today'
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let today = dateFormatter.date(from: "02.06.2025")!

        let weekday = weekdayName(today)
        let week = calculateWeekNumber(for: today, schedule: schedule)
        let lessons = (schedule.effectiveSchedules?[weekday] ?? []).filter { lesson in
            lesson.weekNumber?.contains(week) ?? false
        }
        print("[Widget] Loaded \(lessons.count) lessons for today from App Group.")
        return lessons
    }

    func weekdayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized
    }

    func calculateWeekNumber(for date: Date, schedule: GroupSchedule) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let startDate = schedule.startDate,
              let start = dateFormatter.date(from: startDate) else { return 1 }
        let calendar = Calendar.current
        let selected = calendar.startOfDay(for: date)
        let startDay = calendar.startOfDay(for: start)
        let days = calendar.dateComponents([.day], from: startDay, to: selected).day ?? 0
        return (days / 7) % 4 + 1
    }
}

struct ScheduleWidgetEntryView: View {
    var entry: ScheduleTimelineProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if entry.lessons.isEmpty {
                Text("No lessons today")
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(entry.lessons.prefix(6), id: \ .id) { lesson in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(lesson.startLessonTime ?? "")
                                .font(.caption)
                            Text(lesson.endLessonTime ?? "")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text(lesson.subject ?? "Lesson")
                                .font(.caption)
                                .bold()
                            if let aud = lesson.auditories?.joined(separator: ", "), !aud.isEmpty {
                                Text(aud)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(2)
        .containerBackground(.fill, for: .widget)
    }
}

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleTimelineProvider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Schedule")
        .description("Shows up to 4 lessons for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
