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

    private override init() {
        super.init()

        checkNotificationStatus()

        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization(_ callback: @escaping () -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { _, error in
                if let error {
                    logger.error("DEBUG: \(error.localizedDescription)")
                }

                callback()
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

    private func checkNotificationStatus() {
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
