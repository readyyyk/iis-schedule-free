import Foundation
import Combine

@MainActor
class UserSettings: ObservableObject {
    static let shared = UserSettings()
    private let groupNumberKey = "selectedGroupNumber"
    private let groupNameKey = "selectedGroupName"
    
    @Published var selectedGroupNumber: String? {
        didSet { save() }
    }
    @Published var selectedGroupName: String? {
        didSet { save() }
    }
    
    private init() {
        selectedGroupNumber = UserDefaults.standard.string(forKey: groupNumberKey)
        selectedGroupName = UserDefaults.standard.string(forKey: groupNameKey)
    }
    
    func selectGroup(number: String, name: String) {
        selectedGroupNumber = number
        selectedGroupName = name
    }
    
    private func save() {
        UserDefaults.standard.setValue(selectedGroupNumber, forKey: groupNumberKey)
        UserDefaults.standard.setValue(selectedGroupName, forKey: groupNameKey)
    }
} 
