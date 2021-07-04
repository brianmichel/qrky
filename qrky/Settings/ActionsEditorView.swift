//
//  ActionsEditorView.swift
//  QRky
//
//  Created by Brian Michel on 6/29/21.
//

import SwiftUI

struct ActionsEditorView: View {
    @Binding var actions: [Action]

    @State var actionSelection = Set<Action>()

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            NavigationView {
                VStack(alignment: .leading) {
                    List(actions, id: \.self, selection: $actionSelection) { action in
                        Text(action.title)
                    }.navigationTitle("Actions")
                    HStack {
                        Button("Remove", action: {})
                            .disabled(!removeEnabled())
                        Button("Add", action: {})
                    }
                    .padding()
                    .listStyle(SidebarListStyle())
                }
                VStack {
                    if let action = selectedAction() {
                        ActionEditorView(action: action).padding(.leading)
                    } else {
                        Text("No action selected")
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Divider()
        }
        .frame(width: 500, height: 300)
    }

    private func selectedAction() -> Action? {
        return actionSelection.first
    }

    private func removeEnabled() -> Bool {
        guard let selectedAction = selectedAction() else {
            return false
        }

        return selectedAction.isDeletable
    }
}

struct ActionEditorView: View {
    let action: Action?

    @State private var title: String = ""
    @State private var binaryURL: String = ""
    @State private var arguments: String = ""

    init(action: Action?) {
        self.action = action

        if let action = action {
            self._title = State(initialValue: action.title)
            self._binaryURL = State(initialValue: action.binaryURL.path)
            self._arguments = State(initialValue: action.arguments)
        }
    }

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Title").font(.title2.bold())
                Text("This is what you'll see your action be referred to as."
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Title", text: $title)
                    .disabled(editingDisabled())
            }
            VStack(alignment: .leading) {
                Text("Executable Path").font(.title2.bold())
                Text("The path on disk where the executable for your action exists."
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Executable Path", text: $binaryURL)
                    .disabled(editingDisabled())

            }
            VStack(alignment: .leading) {
                Text("Arguments").font(.title2.bold())
                Text("The arguments that you will be passing to the executable. Please note that you can use {{value}} as a substitute token for the decode code value."
                ).font(.callout).frame(width: 300)
                .foregroundColor(.secondary)
                TextField("Arguments", text: $arguments)
                    .disabled(editingDisabled())
            }
        }
    }

    func editingDisabled() -> Bool {
        guard let action = action else {
            return false
        }
        // If an action is deletable, we should allow for editing.
        return !action.isDeletable
    }
}

struct ActionsEditorView_Previews: PreviewProvider {
    @AppStorage(PreferenceKeys.availableActions) static var actions: [Action] = Action.defaultActions

    static var previews: some View {
        Group {
            ActionsEditorView(actions: $actions)
        }
    }
}
