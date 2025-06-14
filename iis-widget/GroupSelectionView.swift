import SwiftUI

struct GroupSelectionView: View {
    @ObservedObject var viewModel = GroupSelectionViewModel()
    @ObservedObject var userSettings = UserSettings.shared
    @State private var showConfirmation = false
    @State private var selectedGroup: Group?

    var body: some View {
        NavigationView {
            SwiftUI.Group {
                if viewModel.isLoading {
                    ProgressView("Loading groups...")
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry") { viewModel.fetchGroups() }
                    }
                } else {
                    List(viewModel.filteredGroups) { group in
                        let isSelected = userSettings.selectedGroupNumber == group.name
                        Button(action: {
                            selectedGroup = group
                            showConfirmation = true
                        }) {
                            HStack {
                                Text(group.name ?? "<No Name>")
                                if isSelected {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Group")
            .toolbar {
                if userSettings.selectedGroupNumber != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Continue") {}
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search groups")
            .onAppear { viewModel.fetchGroups() }
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Select this group?"),
                    message: Text(selectedGroup?.name ?? ""),
                    primaryButton: .default(Text("Yes")) {
                        if let group = selectedGroup {
                            viewModel.selectGroup(group)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
