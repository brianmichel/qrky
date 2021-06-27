//
//  NotificationsSettingsView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

enum NotificationsState: Int, CaseIterable {
    case on, onWithDuplicates, off

    var description: String {
        switch self {
        case .on:
            return "On"
        case .onWithDuplicates:
            return "On, with duplicates"
        case .off:
            return "Off"
        }
    }
}

struct NotificationsSettingsView: View {
    @AppStorage(PreferenceKeys.notificationState) private var notificationsState: NotificationsState = .on

    @State private var allowBadging = false

    var body: some View {
        VStack {
            Form {
                Picker("Notifications:", selection: $notificationsState) {
                    ForEach(NotificationsState.allCases, id: \.self) { state in
                        Text(state.description).tag(state)
                    }
                }.pickerStyle(InlinePickerStyle())
                Text("Allowing duplicates will let multiple notifications from the same decoded QR code value. This is useful if you want to re-trigger getting a notificationi by jiggling the reader window.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.padding()
            Spacer()
        }
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView().frame(width: 500)
    }
}
