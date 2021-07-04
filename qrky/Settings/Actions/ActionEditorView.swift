//
//  ActionEditorView.swift
//  QRky
//
//  Created by Brian Michel on 7/4/21.
//

import SwiftUI

struct ActionEditorView: View, Sheetable {
    @ObservedObject var model: ActionEditorViewModel

    var trailingSheetButton = AnyView(
            Button("Save", action: {})
        )

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Title").font(.title2.bold())
                Text("This is what you'll see your action be referred to as."
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Title", text: $model.title)
                    .disabled(!model.editingEnabled)
            }
            VStack(alignment: .leading) {
                Text("Executable Path").font(.title2.bold())
                Text("The path on disk where the executable for your action exists."
                ).font(.callout)
                .foregroundColor(.secondary)
                TextField("Executable Path", text: $model.binaryURL)
                    .disabled(!model.editingEnabled)

            }
            VStack(alignment: .leading) {
                Text("Arguments").font(.title2.bold())
                Text("The arguments that you will be passing to the executable. Please note that you can use {{value}} as a substitute token for the decode code value."
                ).font(.callout).frame(width: 300)
                .foregroundColor(.secondary)
                TextField("Arguments", text: $model.arguments)
                    .disabled(!model.editingEnabled)
            }
        }
    }
}

struct ActionEditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActionEditorView(model: ActionEditorViewModel(action: nil)).padding()
            ActionEditorView(model: ActionEditorViewModel(action: Action(title: "Test", binaryURL: URL(fileURLWithPath: "/usr/bin/test"), arguments: ""))).padding()
        }.frame(width: 500)
    }
}
