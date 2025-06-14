import Foundation
import Combine

class NetworkService {
    @MainActor static let shared = NetworkService()
    private let baseURL = URL(string: "https://iis.bsuir.by/api/v1/")!
    private let decoder: JSONDecoder
    
    private init() {
        decoder = JSONDecoder()
    }
    
    // Fetch all groups
    func fetchGroups() -> AnyPublisher<[Group], Error> {
        let url = baseURL.appendingPathComponent("student-groups")
        print("[NetworkService] fetchGroups URL: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                print("[NetworkService] fetchGroups raw data: \(String(data: output.data, encoding: .utf8) ?? "<binary>")")
            })
            .map { $0.data }
            .decode(type: [Group].self, decoder: decoder)
            .timeout(10, scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
            .retry(2)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Fetch group schedule
    func fetchGroupSchedule(groupNumber: String) -> AnyPublisher<GroupSchedule, Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent("schedule"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "studentGroup", value: groupNumber)]
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        print("[NetworkService] fetchGroupSchedule URL: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                print("[NetworkService] fetchGroupSchedule raw data: \(String(data: output.data, encoding: .utf8) ?? "<binary>")")
            })
            .map { $0.data }
            .decode(type: GroupSchedule.self, decoder: decoder)
            .timeout(10, scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
            .retry(2)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Fetch current week
    func fetchCurrentWeek() -> AnyPublisher<Int, Error> {
        let url = baseURL.appendingPathComponent("schedule/current-week")
        print("[NetworkService] fetchCurrentWeek URL: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                print("[NetworkService] fetchCurrentWeek raw data: \(String(data: output.data, encoding: .utf8) ?? "<binary>")")
            })
            .map { $0.data }
            .tryMap { data in
                // The API returns just a number, not JSON
                guard let weekString = String(data: data, encoding: .utf8),
                      let week = Int(weekString.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                    throw URLError(.cannotParseResponse)
                }
                return week
            }
            .timeout(10, scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
            .retry(2)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
} 
