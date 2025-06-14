import Foundation

@MainActor
class CacheService {
    static let shared = CacheService()
    
    // Replace with your actual App Group identifier
    private let appGroupID = "group.todooos.inc.iis-widget"
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    private let scheduleKey = "cachedGroupSchedule"
    private let weekKey = "cachedCurrentWeek"
    private let lastFetchDateKey = "lastFetchDate"
    
    private init() {}
    
    // MARK: - Schedule
    func saveSchedule(_ schedule: GroupSchedule) {
        guard let data = try? JSONEncoder().encode(schedule) else { return }
        userDefaults?.set(data, forKey: scheduleKey)
        userDefaults?.set(Date(), forKey: lastFetchDateKey)
    }
    
    func loadSchedule() -> GroupSchedule? {
        guard let data = userDefaults?.data(forKey: scheduleKey) else { return nil }
        return try? JSONDecoder().decode(GroupSchedule.self, from: data)
    }
    
    // MARK: - Current Week
    func saveCurrentWeek(_ week: Int) {
        userDefaults?.set(week, forKey: weekKey)
        userDefaults?.set(Date(), forKey: lastFetchDateKey)
    }
    
    func loadCurrentWeek() -> Int? {
        return userDefaults?.integer(forKey: weekKey)
    }
    
    // MARK: - Last Fetch Date
    func loadLastFetchDate() -> Date? {
        return userDefaults?.object(forKey: lastFetchDateKey) as? Date
    }
    
    // MARK: - Invalidate Cache
    func clearCache() {
        userDefaults?.removeObject(forKey: scheduleKey)
        userDefaults?.removeObject(forKey: weekKey)
        userDefaults?.removeObject(forKey: lastFetchDateKey)
    }
} 
