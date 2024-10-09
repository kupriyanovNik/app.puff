//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import FirebaseCrashlytics

final class CrashlyticsManager {
    static func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }

    static func sendUnsentReports() {
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
