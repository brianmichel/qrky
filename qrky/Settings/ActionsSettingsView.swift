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
    @AppStorage(PreferenceKeys.availableActions) var actions: [Action] = Action.defaultActions
    @AppStorage(PreferenceKeys.selectedAction) var selectedAction = 0

    @State private var showEditingSheet = false

    var body: some View {
        VStack {
            Form {
                Picker("Default action:", selection: $selectedAction) {
                    ForEach(0..<actions.count) { index in
                        let action = actions[index]
                        Text(action.title).tag(index)
                    }
                }
                Text("This is the action that will be performed automatically after recognizing a QR code.")
                    .font(.callout)
                    .frame(width: 250)
                    .foregroundColor(.secondary)
                HStack {
                    Button("Edit actions...", action: {
                        showEditingSheet.toggle()
                    })
                }
            }.padding()
            Spacer()
        }
        .sheet(isPresented: $showEditingSheet, content: {
            SheetView(title: "Actions", subtitle: nil) {
                ActionsEditorView(actions: $actions)
            }
        })
    }
}

struct ActionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsSettingsView()
    }
}
