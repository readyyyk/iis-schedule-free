import Foundation
import Combine

@MainActor
class GroupSelectionViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText: String = ""
    private var cancellable: AnyCancellable?
    
    var filteredGroups: [Group] {
        guard !searchText.isEmpty else { return groups }
        return groups.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
    }
    
    func fetchGroups() {
        isLoading = true
        error = nil
        searchText = ""
        cancellable = NetworkService.shared.fetchGroups()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.error = err.localizedDescription
                }
            }, receiveValue: { [weak self] groups in
                self?.groups = groups
            })
    }
    
    func selectGroup(_ group: Group) {
        guard let name = group.name else { return }
        UserSettings.shared.selectGroup(number: name, name: name)
    }
} 
