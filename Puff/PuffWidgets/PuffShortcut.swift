//
//  PuffShortcut.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 19.10.2024.
//

import AppIntents

struct PuffShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: PuffIntent(),
            phrases: [
                "Puff"
            ],
            shortTitle: "Puff",
            systemImageName: "plus"
        )
    }
}
