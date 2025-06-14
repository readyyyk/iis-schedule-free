import Foundation
import Combine

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var schedule: GroupSchedule?
    @Published var currentWeek: Int?
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadSchedule(for groupNumber: String) {
        print("[ScheduleViewModel] Start loading schedule for group: \(groupNumber)")
        isLoading = true
        error = nil
        
        let emptySchedule = GroupSchedule(
            studentGroupDto: nil,
            employeeDto: nil,
            schedules: nil,
            previousSchedules: nil,
            exams: nil,
            startDate: nil,
            endDate: nil,
            startExamsDate: nil,
            endExamsDate: nil,
            previousTerm: nil,
            currentTerm: nil,
            currentPeriod: nil
        )
        let schedulePublisher = NetworkService.shared.fetchGroupSchedule(groupNumber: groupNumber)
            .handleEvents(receiveOutput: { schedule in
                print("[ScheduleViewModel] API schedule fetch success. Caching result.")
                CacheService.shared.saveSchedule(schedule)
            })
            .catch { [weak self] err -> AnyPublisher<GroupSchedule, Never> in
                print("[ScheduleViewModel] Schedule fetch error: \(err.localizedDescription)")
                self?.error = err.localizedDescription
                if let cached = CacheService.shared.loadSchedule() {
                    print("[ScheduleViewModel] Loaded schedule from cache.")
                    return Just(cached).eraseToAnyPublisher()
                } else {
                    print("[ScheduleViewModel] No cached schedule available.")
                    return Empty().eraseToAnyPublisher()
                }
            }
            .replaceEmpty(with: emptySchedule)
        
        let weekPublisher = NetworkService.shared.fetchCurrentWeek()
            .handleEvents(receiveOutput: { week in
                print("[ScheduleViewModel] API week fetch success. Caching result.")
                CacheService.shared.saveCurrentWeek(week)
            })
            .catch { [weak self] err -> AnyPublisher<Int, Never> in
                print("[ScheduleViewModel] Week fetch error: \(err.localizedDescription)")
                self?.error = (self?.error ?? "") + "\nWeek: " + err.localizedDescription
                if let cached = CacheService.shared.loadCurrentWeek() {
                    print("[ScheduleViewModel] Loaded week from cache.")
                    return Just(cached).eraseToAnyPublisher()
                } else {
                    print("[ScheduleViewModel] No cached week available.")
                    return Empty().eraseToAnyPublisher()
                }
            }
            .replaceEmpty(with: -1)
        
        Publishers.Zip(schedulePublisher, weekPublisher)
            .sink { [weak self] (schedule, week) in
                print("[ScheduleViewModel] Finished loading. Schedule: \(schedule != nil), Week: \(week)")
                self?.schedule = schedule
                self?.currentWeek = week == -1 ? nil : week
                self?.isLoading = false
                if (schedule.schedules == nil && schedule.previousSchedules == nil) || week == -1 {
                    let errMsg = "No schedule data available from API or cache."
                    print("[ScheduleViewModel] ERROR: \(errMsg)")
                    self?.error = (self?.error ?? "") + "\n" + errMsg
                }
                if schedule.schedules == nil && schedule.previousSchedules == nil && self?.error == nil {
                    self?.error = "No schedule data available."
                }
            }
            .store(in: &cancellables)
    }
} 
