//
//  Actioner.swift
//  QRky
//
//  Created by Brian Michel on 6/29/21.
//

import Foundation
import SwiftUI

struct Actioner {
    @AppStorage(PreferenceKeys.availableActions) var actions: [Action] = Action.defaultActions
    @AppStorage(PreferenceKeys.selectedAction) var selectedAction = 0

    private let formatter = ActionFormatter()

    func action(item: DecodedItem) {
        let action = actions[selectedAction]
        let process = formatter.process(for: action, item: item)

        DispatchQueue.global().async {
            do {
                try process.run()
            } catch (let error) {
                print("Got error from trying to running process: \(error)")
            }
        }
    }
}
