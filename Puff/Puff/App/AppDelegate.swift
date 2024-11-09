//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import Foundation
import Firebase
import UIKit
import Adapty
import AdaptyUI

class AppDelegate: NSObject, UIApplicationDelegate, AdaptyDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        CrashlyticsManager.sendUnsentReports()

        Adapty.delegate = self

        let configurationBuilder = Adapty.Configuration
                .Builder(withAPIKey: "public_live_LC6FFziH.wjp8sTYhrWFpFdT97ugS")
                .with(observerMode: false)
                .with(idfaCollectionDisabled: false)
                .with(ipAddressCollectionDisabled: false)

        Adapty.activate(with: configurationBuilder) { error in
            if let error {
                logger.error("Error while configuring Adapty: \(error.localizedDescription)")
            }
        }

        Adapty.logLevel = .verbose

        AdaptyUI.activate()

        logger.info(
            """
            Successfully opened the app.
            App version \(Bundle.main.appVersion).
            App build \(Bundle.main.appBuild).
            """
        )

        return true
    }

    func didLoadLatestProfile(_ profile: AdaptyProfile) {
        Adapty.getProfile { result in
            if let profile = try? result.get() {
                let isUserPremium: Bool = profile.accessLevels["premium"]?.isActive ?? false

                AdaptySubscriptionManager.shared.isPremium = isUserPremium
            }
        }
    }
}
