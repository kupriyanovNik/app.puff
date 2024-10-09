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
                        logger.error("DEBUG: \(error.localizedDescription)")
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
                print("DEBUG: unable to send notification: \(error)")
            } else {
                print("added notification", title, body, dateComponents)
            }
        }

        return id
    }
}

// MARK: - First Day Notification
extension NotificationManager {
    func sendFirstDaysNotifications() {
        if let _ = defaults.value(forKey: "firstDaysNotificationsIDs") {
            return
        }

        var ids: [String] = []

        let titles = [
            "🔥 Сегодня - тот самый день",
            "⚡️ Время действовать!",
            "🕺 Сделайте первый шаг"
        ]
        let body = "Начните план бросания"
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
    }

    func deleteFirstDayNotification() {
        if let ids = defaults.value(forKey: "firstDaysNotificationsIDs") as? [String] {
            removeNotifications(with: ids)
            defaults.set(nil, forKey: "firstDaysNotificationsIDs")
        }
    }
}
