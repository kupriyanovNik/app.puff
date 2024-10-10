//
//  AppDelegate.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import FirebaseAnalytics

final class AnalyticsManager {
    static func logEvent(event: AnalyticsEvent) {
        Analytics.logEvent(event.title, parameters: event.parameters)

        print("Event:", event.title, event.parameters)
    }

    enum AnalyticsEvent {
        case openedPaywall(tab: Int)
        case seenOnboarding(pageNumber: Int)
        case acceptedNotifications
        case resetedPlan
        case canceledSubscription(reasons: [String], feedback: String)
        case startedPlan(initialSmokes: Int, daysInPlan: Int)
        case addedMoreSmokes(count: Int)
        case extendedPlan
        case extendedPlanInLastDay
        case openedAppStoreFromUpdateActionMenu

        var title: String {
            switch self {
            case .openedPaywall: "UserOpenedPaywall"
            case .seenOnboarding: "UserSeenOnboarding"
            case .acceptedNotifications: "UserAcceptedNotifications"
            case .resetedPlan: "UserResetedPlan"
            case .canceledSubscription: "UserCanceledSubscription"
            case .startedPlan: "UserStartedPlan"
            case .addedMoreSmokes: "UserAddedMoreSmokes"
            case .extendedPlan: "UserExtendedPlan"
            case .extendedPlanInLastDay: "UserExtendedPlanInLastDay"
            case .openedAppStoreFromUpdateActionMenu: "UserOpenedAppStoreFromUpdateActionMenu"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .openedPaywall(let tab):
                ["FromTab": tab]

            case .seenOnboarding(let pageNumber):
                ["PageNumber": pageNumber]

            case .canceledSubscription(let reasons, let feedback):
                ["Reasons": reasons.joined(separator: ";"), "Feedback": feedback]

            case .startedPlan(let initialSmokes, let daysInPlan):
                ["InitialSmokes": initialSmokes, "DaysInPlan": daysInPlan]

            case .addedMoreSmokes(let count):
                ["Count": count]

            case .acceptedNotifications, .resetedPlan, .extendedPlan, .extendedPlanInLastDay, .openedAppStoreFromUpdateActionMenu: nil
            }
        }
    }
}
