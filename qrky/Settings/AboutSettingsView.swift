//
//  AboutSettingsView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 5) {
            Image("AppIcon-Large").resizable().frame(width: 150, height: 150).accentColor(.primary)
            Text("QRky v\(QRkyVersionInformation.versionNumber)").font(.largeTitle)

            Form {
                Section(header: header(), footer: footer()) {
                    Label(title: {
                        Text("\(QRkyVersionInformation.buildNumber)")
                    }, icon: {
                        Image(systemName: "clock.fill")
                    })
                    .font(Font.system(.body, design: .monospaced))
                    .help("The build number of the application.")
                    .foregroundColor(.secondary)
                    Label(title: {
                        Text("\(QRkyVersionInformation.gitRevision)")
                    }, icon: {
                        Image(systemName: "hammer.fill")
                    })
                    .font(Font.system(.body, design: .monospaced))
                    .help("The Git SHA the application was built from.")
                    .foregroundColor(.secondary) 
                }
            }
        }.padding()
    }

    func header() -> some View {
        return Text("Build Information")
    }

    func footer() -> some View {
        return Label(title: {
            Link("@brianmichel", destination: URL(string: "https://twitter.com/brianmichel")!)
        }, icon: {
            Image(systemName: "link")
        })
        .font(Font.system(.body, design: .monospaced))
        .help("Drop me a message if you have some time.")
    }
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}
