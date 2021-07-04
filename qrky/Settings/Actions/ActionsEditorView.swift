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
                        ActionEditorView(model: ActionEditorViewModel(action: action)).padding(.leading)
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

struct ActionsEditorView_Previews: PreviewProvider {
    @AppStorage(PreferenceKeys.availableActions) static var actions: [Action] = Action.defaultActions

    static var previews: some View {
        Group {
            ActionsEditorView(actions: $actions)
        }
    }
}
