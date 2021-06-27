//
//  FormGroupView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

struct FormGroupView<Content: View>: View {
    let label: Text
    let content: Content

    init(label: Text, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }

    var body: some View {
        Group {
            HStack(alignment: .firstTextBaseline) {
                self.label
                VStack(alignment: .leading) {
                    self.content
                }
            }
            .padding()
        }
    }
}

struct FormGroupView_Previews: PreviewProvider {
    static var previews: some View {
        FormGroupView(label: Text("Options:")) {
            Toggle("One", isOn: .constant(true))
            VStack(alignment: .leading) {
                Toggle("Two", isOn: .constant(true))
                Text("Some really long subtext for this option and just for this option.").font(.callout).foregroundColor(.secondary)
            }
            Toggle("Three", isOn: .constant(false))
        }.frame(width: 200)
    }
}
