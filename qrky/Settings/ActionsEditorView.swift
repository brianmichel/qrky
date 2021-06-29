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
        VStack {
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
            }.cornerRadius(10)
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
    let action: Action

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Title").font(.title2.bold())
                Text("This is what you'll see your action be referred to by QRky."
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Title", text: .constant(action.title))
            }
            VStack(alignment: .leading) {
                Text("Executable Path").font(.title2.bold())
                Text("The path on disk where the executable for your action exists. "
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Executable Path", text: .constant(action.binaryURL.path))
            }
            VStack(alignment: .leading) {
                Text("Arguments").font(.title2.bold())
                Text("The arguments that you will be passing to the executable. Please note that you can use {{value}} as a substitute token for the decode QR code value."
                ).font(.callout).frame(width: 300)
                .foregroundColor(.secondary)
                TextField("Arguments", text: .constant(action.arguments))
            }
        }
    }
}

struct ActionsEditorView_Previews: PreviewProvider {
    @AppStorage(PreferenceKeys.availableActions) static var actions: [Action] = Action.defaultActions

    static var previews: some View {
        Group {
            ActionsEditorView(actions: $actions)
//            ActionEditorView(action: Action(
//                                title: "iOS Simulator Deep Link",
//                                            binaryURL: URL(fileURLWithPath: "/usr/bin/xcrun"),
//                                arguments: "simctl openURL booted \"{{value}}\"'"))
//                .padding()
        }
    }
}
