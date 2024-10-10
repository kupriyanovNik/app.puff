//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import Foundation
import Firebase
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        CrashlyticsManager.sendUnsentReports()

        return true
    }
}
