//
//  NotificationManager.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import Foundation
import UserNotificationsUI

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    var isNotificationEnabled: Bool = false

    private let calendar = Calendar.current
    private let defaults = UserDefaults.standard

    private override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self

        checkNotificationStatus()
    }

    func requestAuthorization(callback: @escaping () -> Void = {}) {
        if isNotificationEnabled {
            DispatchQueue.main.async { callback() }
        } else {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
                    if let error {
                        CrashlyticsManager.log(error.localizedDescription)
                    }

                    DispatchQueue.main.async { callback() }
                }
        }

        self.checkNotificationStatus()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .list, .banner])
    }

    func removeNotifications(with ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }

    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        deleteNotificationsByUDKey("scheduledNotificationsIDs")
        deleteNotificationsByUDKey("firstDaysNotificationsIDs")
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { status in
                switch status.authorizationStatus {
                case .denied, .ephemeral:
                    self.isNotificationEnabled = false
                case .authorized, .notDetermined, .provisional:
                    self.isNotificationEnabled = true
                @unknown default:
                    print("DEBUG: unowned notification status")
                }
            }
    }

    @discardableResult
    private func sendNotification(title: String, body: String, dateComponents: DateComponents) -> String {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let id = UUID().uuidString

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                CrashlyticsManager.log(error.localizedDescription)
            }
        }

        return id
    }

    private func deleteNotificationsByUDKey(_ key: String) {
        if let ids = defaults.value(forKey: key) as? [String] {
            removeNotifications(with: ids)
            defaults.set(nil, forKey: key)
        }
    }
}

// MARK: - First Days Notification
extension NotificationManager {
    func sendFirstDaysNotifications() {
        if let _ = defaults.value(forKey: "firstDaysNotificationsIDs") {
            return
        }

        var ids: [String] = []

        let titles = [
            "Notifications.FistDayNotificationHeader1".l,
            "Notifications.FistDayNotificationHeader2".l,
            "Notifications.FistDayNotificationHeader3".l
        ]
        let body = "Notifications.FirstDaysNotificationSubheader".l
        let dates = [
            Date(),
            Date().tomorrow,
            Date().tomorrow.tomorrow
        ]

        for index in 0..<3 {
            var dateComp = calendar.dateComponents([.year, .month, .day], from: dates[index])
            dateComp.hour = 22
            dateComp.minute = 0
            let title = titles[index]

            ids.append(sendNotification(title: title, body: body, dateComponents: dateComp))
        }

        defaults.set(ids, forKey: "firstDaysNotificationsIDs")

        scheduleNotifications()
    }
}

// MARK: - Daily Notifications
extension NotificationManager {
    func scheduleNotifications(
        limits: [Int] = []
    ) {
        var ids: [String] = []

        if limits.isEmpty {
            let dates: [Date] = (0...25).map {
                calendar.date(byAdding: .day, value: $0, to: .now) ?? .now
            }

            for index in (0...25) {
                let title: String = "Notifications.DailyNotifications".l
                let body = "Notifications.DailyNotificationsFreeBody".l

                var dateComp = calendar.dateComponents([.year, .month, .day], from: dates[index])
                dateComp.hour = 10
                dateComp.minute = 0

                ids.append(sendNotification(title: title, body: body, dateComponents: dateComp))
            }
        } else {
            let dates: [Date] = limits.indices.map {
                calendar.date(byAdding: .day, value: $0, to: .now) ?? .now
            }

            for index in limits.indices {
                let title: String = "Notifications.DailyNotifications".l
                let body = "Notifications.DailyNotificationsPremiumBody".l.formatByDivider(
                    divider: "{count}",
                    count: limits[index]
                )

                var dateComp = calendar.dateComponents([.year, .month, .day], from: dates[index])
                dateComp.hour = 10
                dateComp.minute = 0

                ids.append(sendNotification(title: title, body: body, dateComponents: dateComp))
            }
        }


        defaults.set(ids, forKey: "scheduledNotificationsIDs")
    }
}
