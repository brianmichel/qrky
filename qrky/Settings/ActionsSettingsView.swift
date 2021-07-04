//
//  ActionsSettingsView.swift
//  QRky
//
//  Created by Brian Michel on 6/28/21.
//

import SwiftUI

struct ActionFormatter {
    let substitutionToken = "{{value}}"

    func process(for action: Action, item: DecodedItem) -> Process {
        let arguments = action.arguments
            .replacingOccurrences(of: substitutionToken, with: item.value)
            .split(separator: " ")
            .map(String.init)

        let process = Process()
        process.executableURL = action.binaryURL
        process.arguments = arguments

        return process
    }
}

struct Action: Codable, Hashable {
    var id: String {
        return "action.\(title)"
    }

    var title: String
    var binaryURL: URL
    var arguments: String
    var isDeletable: Bool = false
}

extension Action {
    static var defaultActions: [Action] {
        return [
            Action.doNothing,
            Action.say
        ]
    }
    static var doNothing: Action {
        return Action(title: "Do nothing", binaryURL: URL(fileURLWithPath: ""), arguments: "")
    }

    static var say: Action {
        Action(title: "Say value", binaryURL: URL(fileURLWithPath: "/usr/bin/say"), arguments: "{{value}}")
    }
}

struct ActionsSettingsView: View {
    @AppStorage(PreferenceKeys.actionsEnabled) var actionsEnabled = false

    @AppStorage(PreferenceKeys.availableActions) var actions: [Action] = Action.defaultActions
    @AppStorage(PreferenceKeys.selectedAction) var selectedAction = 0

    @State private var showEditingSheet = false
    @State private var showAddSheet = false

    @State var actionSelection = Set<Action>()

    var body: some View {
        VStack {
            Form {
                Toggle("Allow actions", isOn: $actionsEnabled)
                VStack(alignment: .leading) {
                    List(actions, id: \.self, selection: $actionSelection) { action in
                        HStack {
                            Text(action.title)
                            Spacer()
                        }
                        .onTapGesture(count: 2, perform: {
                            showEditingSheet.toggle()
                        })
                    }
                    .listStyle(SidebarListStyle())
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        Button("Add", action: {
                            showAddSheet.toggle()
                        })
                    }
                }
                .disabled(!actionsEnabled)
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $showEditingSheet, content: {
            let action = actionSelection.first
            SheetView(title: "Edit Action", subtitle: nil) {
                ActionEditorView(action: action)
            }
        })
        .sheet(isPresented: $showAddSheet, content: {
            SheetView(title: "Add action", subtitle: nil) {
                ActionEditorView(action: nil)
            }
        })
    }
}

struct ActionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsSettingsView()
    }
}
