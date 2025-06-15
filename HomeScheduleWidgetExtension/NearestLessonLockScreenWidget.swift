import WidgetKit
import SwiftUI
import Foundation

struct NearestLessonEntry: TimelineEntry {
    let date: Date
    let lesson: Lesson?
}

struct NearestLessonProvider: TimelineProvider {
    func placeholder(in context: Context) -> NearestLessonEntry {
        NearestLessonEntry(date: Date(), lesson: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (NearestLessonEntry) -> ()) {
        let entry = NearestLessonEntry(date: Date(), lesson: loadNearestLesson())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NearestLessonEntry>) -> ()) {
        let entry = NearestLessonEntry(date: Date(), lesson: loadNearestLesson())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    func loadNearestLesson() -> Lesson? {
        let userDefaults = UserDefaults(suiteName: appGroupID)
        guard let data = userDefaults?.data(forKey: "cachedGroupSchedule"),
              let schedule = try? JSONDecoder().decode(GroupSchedule.self, from: data) else {
            return nil
        }
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayString = dateFormatter.string(from: now)
        let calendar = Calendar.current
        let weekday = weekdayName(now)
        let week = calculateWeekNumber(for: now, schedule: schedule)
        func parse(_ str: String?) -> Date? {
            guard let str = str, let d = dateFormatter.date(from: str) else { return nil }
            return calendar.startOfDay(for: d)
        }
        let selected = calendar.startOfDay(for: now)
        let startDate = parse(schedule.startDate)
        let endDate = parse(schedule.endDate)
        let startExamsDate = parse(schedule.startExamsDate)
        let endExamsDate = parse(schedule.endExamsDate)
        func inRange(_ start: Date?, _ end: Date?) -> Bool {
            guard let s = start, let e = end else { return false }
            return selected >= s && selected <= e
        }
        let regular = (schedule.effectiveSchedules?[weekday] ?? []).filter { lesson in
            let weekMatch = lesson.weekNumber?.contains(week) ?? false
            let isExamOrConsult = lesson.lessonTypeAbbrev == "Экзамен" || lesson.lessonTypeAbbrev == "Консультация"
            let isExamByDate = lesson.dateLesson != nil
            return weekMatch && !isExamOrConsult && !isExamByDate
        }
        let exams: [Lesson]
        if inRange(startExamsDate, endExamsDate) {
            exams = (schedule.exams ?? []).filter { lesson in
                guard let date = lesson.dateLesson else { return false }
                return date == todayString
            }
        } else {
            exams = []
        }
        let inExams = inRange(startExamsDate, endExamsDate)
        let inSemester = inRange(startDate, endDate) && !inExams
        let lessons: [Lesson]
        if inExams {
            lessons = exams.sorted { ($0.startLessonTime ?? "") < ($1.startLessonTime ?? "") }
        } else if inSemester {
            lessons = regular.sorted { ($0.startLessonTime ?? "") < ($1.startLessonTime ?? "") }
        } else {
            lessons = []
        }
        let nowTime = timeString(from: now)
        let nearest = lessons.first { lesson in
            guard let start = lesson.startLessonTime else { return false }
            return start >= nowTime
        } ?? lessons.last
        return nearest
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

    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct NearestLessonLockScreenWidgetEntryView: View {
    var entry: NearestLessonEntry

    var body: some View {
        if let lesson = entry.lesson {
            HStack(alignment: .center, spacing: 8) {
                Text(lesson.subject ?? "Lesson")
                    .font(.headline)
                VStack(spacing: 2) {
                    if let start = lesson.startLessonTime, let end = lesson.endLessonTime {
                        Text("\(start) - \(end)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let aud = lesson.auditories?.joined(separator: ", "), !aud.isEmpty {
                        Text(aud)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .containerBackground(.fill, for: .widget)
        } else {
            Text("No more lessons today")
                .font(.headline)
                .foregroundColor(.secondary)
                .containerBackground(.fill, for: .widget)
        }
    }
}

struct NearestLessonLockScreenWidget: Widget {
    let kind: String = "NearestLessonLockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NearestLessonProvider()) { entry in
            NearestLessonLockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nearest Lesson")
        .description("Shows the nearest lesson for today on the lock screen.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline])
    }
} 
