import Foundation

// MARK: - Group Model
struct Group: Codable, Identifiable {
    let id: Int?
    let name: String?
    let facultyId: Int?
    let facultyAbbrev: String?
    let facultyName: String?
    let specialityDepartmentEducationFormId: Int?
    let specialityName: String?
    let specialityAbbrev: String?
    let course: Int?
    let calendarId: String?
    let educationDegree: Int?
    let specialityCode: String?
    let numberOfStudents: Int?
}

// MARK: - Employee Model
struct Employee: Codable, Identifiable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let middleName: String?
    let degree: String?
    let degreeAbbrev: String?
    let rank: String?
    let photoLink: String?
    let calendarId: String?
    let urlId: String?
    let email: String?
    let jobPositions: String?
    let chief: Bool?
}

// MARK: - Lesson Model
struct Lesson: Codable, Identifiable {
    let id = UUID() // Local unique ID for SwiftUI
    let weekNumber: [Int]?
    let studentGroups: [Group]?
    let numSubgroup: Int?
    let auditories: [String]?
    let startLessonTime: String?
    let endLessonTime: String?
    let subject: String?
    let subjectFullName: String?
    let note: String?
    let lessonTypeAbbrev: String?
    let dateLesson: String?
    let startLessonDate: String?
    let endLessonDate: String?
    let announcement: Bool?
    let split: Bool?
    let employees: [Employee]?
    
    enum CodingKeys: String, CodingKey {
        case weekNumber, studentGroups, numSubgroup, auditories, startLessonTime, endLessonTime, subject, subjectFullName, note, lessonTypeAbbrev, dateLesson, startLessonDate, endLessonDate, announcement, split, employees
    }
}

// MARK: - Schedule Model
struct ScheduleDay: Codable {
    let lessons: [Lesson]?
}

struct GroupSchedule: Codable {
    let studentGroupDto: Group?
    let employeeDto: Employee?
    let schedules: [String: [Lesson]]?
    let previousSchedules: [String: [Lesson]]?
    let exams: [Lesson]?
    let startDate: String?
    let endDate: String?
    let startExamsDate: String?
    let endExamsDate: String?
    let previousTerm: String?
    let currentTerm: String?
    let currentPeriod: String?
}

extension GroupSchedule {
    var effectiveSchedules: [String: [Lesson]]? {
        return schedules ?? previousSchedules
    }
} 
