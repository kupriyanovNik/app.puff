//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import FirebaseCrashlytics
import OSLog

final class CrashlyticsManager {
    static func log(_ message: String, logType: OSLogType? = .error) {
        Crashlytics.crashlytics().log(message)

        if let logType {
            logger.log(level: logType, "\(message)")
        }
    }

    static func sendUnsentReports() {
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
