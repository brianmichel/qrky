//
//  SheetView.swift
//  QRky
//
//  Created by Brian Michel on 6/28/21.
//

import SwiftUI

protocol Sheetable {
    var trailingSheetButton: AnyView { get }
}
    
struct SheetView<Content: View & Sheetable>: View {
    @Environment(\.presentationMode) var presentationMode

    private let content: Content

    let title: String
    let subtitle: String?
    

    init(title: String, subtitle: String?, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text(title).font(.title)
                Text(subtitle ?? "")
                    .foregroundColor(.secondary)
            }
            content
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Dismiss")
                }).keyboardShortcut(KeyEquivalent.escape)
                Spacer()
                content.trailingSheetButton.onTapGesture(perform: {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        .frame(maxWidth: 500)
        .padding()
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(title: "Found QR Code", subtitle: "Found the QR code 'https://rad.cool/stuff inside of this code. Would you like to copy it to your clipboard?") {
            TestSheetView()
        }
    }
}

fileprivate struct TestSheetView: View, Sheetable {
    let trailingSheetButton = AnyView(Button("Testing", action: {}))

    var body: some View {
        Text("I'm the testing body")
    }
}
