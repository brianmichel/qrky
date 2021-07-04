//
//  ActionEditorViewModel.swift
//  QRky
//
//  Created by Brian Michel on 7/4/21.
//

import Combine

final class ActionEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var binaryURL: String = ""
    @Published var arguments: String = ""
    @Published private(set) var editingEnabled = true
    @Published private(set) var saveEnabled = false

    private var cancellables = Set<AnyCancellable>()

    init(action: Action?) {
        if let action = action {
            editingEnabled = !action.isDeletable
            self.title = action.title
            self.binaryURL = action.binaryURL.path
            self.arguments = action.arguments
        }

        Publishers.MergeMany(
            $title,
            $binaryURL,
            $arguments
        ).sink { [weak self] _ in
            self?.checkForSaveEnabled()
        }.store(in: &cancellables)
    }

    private func checkForSaveEnabled() {
        saveEnabled = title.count > 0 && binaryURL.count > 0 && arguments.count > 0
    }
}
