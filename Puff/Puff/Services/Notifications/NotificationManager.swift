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

    func removeNotification(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
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
}

// MARK: - First Day Notification
extension NotificationManager {
    func sendFirstDayNotification() {
        if let _ = defaults.value(forKey: "firstDayNotificationID") {
            return
        }

        let title: String = "🔥 Сегодня - тот самый день"
        let body: String = "Начните план бросания"

        let id = UUID().uuidString

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: .now)
        dateComponents.hour = 22
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("DEBUG: unable to send notification: \(error)")
            }
        }

        defaults.set(id, forKey: "firstDayNotificationID")
    }

    func deleteFirstDayNotification() {
        if let id = defaults.value(forKey: "firstDayNotificationID") as? String {
            removeNotification(with: id)
        }
    }
}
