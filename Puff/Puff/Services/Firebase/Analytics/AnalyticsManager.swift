//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import FirebaseAnalytics

final class AnalyticsManager {
    static func logEvent(_ name: String, params: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
}
