import Foundation

// MARK: - Group Model
public struct Group: Codable, Identifiable {
    public let id: Int?
    public let name: String?
    public let facultyId: Int?
    public let facultyAbbrev: String?
    public let facultyName: String?
    public let specialityDepartmentEducationFormId: Int?
    public let specialityName: String?
    public let specialityAbbrev: String?
    public let course: Int?
    public let calendarId: String?
    public let educationDegree: Int?
    public let specialityCode: String?
    public let numberOfStudents: Int?
    public init(id: Int?, name: String?, facultyId: Int?, facultyAbbrev: String?, facultyName: String?, specialityDepartmentEducationFormId: Int?, specialityName: String?, specialityAbbrev: String?, course: Int?, calendarId: String?, educationDegree: Int?, specialityCode: String?, numberOfStudents: Int?) {
        self.id = id
        self.name = name
        self.facultyId = facultyId
        self.facultyAbbrev = facultyAbbrev
        self.facultyName = facultyName
        self.specialityDepartmentEducationFormId = specialityDepartmentEducationFormId
        self.specialityName = specialityName
        self.specialityAbbrev = specialityAbbrev
        self.course = course
        self.calendarId = calendarId
        self.educationDegree = educationDegree
        self.specialityCode = specialityCode
        self.numberOfStudents = numberOfStudents
    }
}

// MARK: - Employee Model
public struct Employee: Codable, Identifiable {
    public let id: Int?
    public let firstName: String?
    public let lastName: String?
    public let middleName: String?
    public let degree: String?
    public let degreeAbbrev: String?
    public let rank: String?
    public let photoLink: String?
    public let calendarId: String?
    public let urlId: String?
    public let email: String?
    public let jobPositions: String?
    public let chief: Bool?
    public init(id: Int?, firstName: String?, lastName: String?, middleName: String?, degree: String?, degreeAbbrev: String?, rank: String?, photoLink: String?, calendarId: String?, urlId: String?, email: String?, jobPositions: String?, chief: Bool?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.degree = degree
        self.degreeAbbrev = degreeAbbrev
        self.rank = rank
        self.photoLink = photoLink
        self.calendarId = calendarId
        self.urlId = urlId
        self.email = email
        self.jobPositions = jobPositions
        self.chief = chief
    }
}

// MARK: - Lesson Model
public struct Lesson: Codable, Identifiable {
    public let id = UUID() // Local unique ID for SwiftUI
    public let weekNumber: [Int]?
    public let studentGroups: [Group]?
    public let numSubgroup: Int?
    public let auditories: [String]?
    public let startLessonTime: String?
    public let endLessonTime: String?
    public let subject: String?
    public let subjectFullName: String?
    public let note: String?
    public let lessonTypeAbbrev: String?
    public let dateLesson: String?
    public let startLessonDate: String?
    public let endLessonDate: String?
    public let announcement: Bool?
    public let split: Bool?
    public let employees: [Employee]?
    public init(weekNumber: [Int]?, studentGroups: [Group]?, numSubgroup: Int?, auditories: [String]?, startLessonTime: String?, endLessonTime: String?, subject: String?, subjectFullName: String?, note: String?, lessonTypeAbbrev: String?, dateLesson: String?, startLessonDate: String?, endLessonDate: String?, announcement: Bool?, split: Bool?, employees: [Employee]?) {
        self.weekNumber = weekNumber
        self.studentGroups = studentGroups
        self.numSubgroup = numSubgroup
        self.auditories = auditories
        self.startLessonTime = startLessonTime
        self.endLessonTime = endLessonTime
        self.subject = subject
        self.subjectFullName = subjectFullName
        self.note = note
        self.lessonTypeAbbrev = lessonTypeAbbrev
        self.dateLesson = dateLesson
        self.startLessonDate = startLessonDate
        self.endLessonDate = endLessonDate
        self.announcement = announcement
        self.split = split
        self.employees = employees
    }
    public enum CodingKeys: String, CodingKey {
        case weekNumber, studentGroups, numSubgroup, auditories, startLessonTime, endLessonTime, subject, subjectFullName, note, lessonTypeAbbrev, dateLesson, startLessonDate, endLessonDate, announcement, split, employees
    }
}

// MARK: - Schedule Model
public struct ScheduleDay: Codable {
    public let lessons: [Lesson]?
    public init(lessons: [Lesson]?) {
        self.lessons = lessons
    }
}

public struct GroupSchedule: Codable {
    public let studentGroupDto: Group?
    public let employeeDto: Employee?
    public let schedules: [String: [Lesson]]?
    public let previousSchedules: [String: [Lesson]]?
    public let exams: [Lesson]?
    public let startDate: String?
    public let endDate: String?
    public let startExamsDate: String?
    public let endExamsDate: String?
    public let previousTerm: String?
    public let currentTerm: String?
    public let currentPeriod: String?
    public init(studentGroupDto: Group?, employeeDto: Employee?, schedules: [String: [Lesson]]?, previousSchedules: [String: [Lesson]]?, exams: [Lesson]?, startDate: String?, endDate: String?, startExamsDate: String?, endExamsDate: String?, previousTerm: String?, currentTerm: String?, currentPeriod: String?) {
        self.studentGroupDto = studentGroupDto
        self.employeeDto = employeeDto
        self.schedules = schedules
        self.previousSchedules = previousSchedules
        self.exams = exams
        self.startDate = startDate
        self.endDate = endDate
        self.startExamsDate = startExamsDate
        self.endExamsDate = endExamsDate
        self.previousTerm = previousTerm
        self.currentTerm = currentTerm
        self.currentPeriod = currentPeriod
    }
}

public extension GroupSchedule {
    var effectiveSchedules: [String: [Lesson]]? {
        return schedules ?? previousSchedules
    }
} 
