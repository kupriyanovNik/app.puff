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

        logger.info("Event: \(event.title)")
    }

    static func logNonExpectedEvent(message: String) {
        Analytics.logEvent(message, parameters: nil)
    }

    enum AnalyticsEvent {
        case openedPaywall(tab: Int)
        case seenOnboarding(pageNumber: Int)
        case skippedSurveyAndPlanCreating
        case acceptedNotifications
        case resetedPlan
        case canceledSubscription(reasons: [String], feedback: String)
        case startedPlan(initialSmokes: Int, daysInPlan: Int)
        case addedMoreSmokes(count: Int)
        case extendedPlan
        case extendedPlanInLastDay
        case openedAppStoreFromUpdateActionMenu

        case first2DaysStatistics(day1Count: Int, day1Limit: Int?, day2Count: Int, day2Limit: Int?)

        var title: String {
            switch self {
            case .openedPaywall: "UserOpenedPaywall"
            case .seenOnboarding: "UserSeenOnboarding"
            case .skippedSurveyAndPlanCreating: "UserSkippedSurveyAndPlancreating"
            case .acceptedNotifications: "UserAcceptedNotifications"
            case .resetedPlan: "UserResetedPlan"
            case .canceledSubscription: "UserCanceledSubscription"
            case .startedPlan: "UserStartedPlan"
            case .addedMoreSmokes: "UserAddedMoreSmokes"
            case .extendedPlan: "UserExtendedPlan"
            case .extendedPlanInLastDay: "UserExtendedPlanInLastDay"
            case .openedAppStoreFromUpdateActionMenu: "UserOpenedAppStoreFromUpdateActionMenu"
            case .first2DaysStatistics: "StatisticsForFirst2Days"
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

            case .first2DaysStatistics(let day1Count, let day1Limit, let day2Count, let day2Limit):
                [
                    "Day1Count": day1Count,
                    "Day1Limit": day1Limit.safeUnwrapAsString(),
                    "Day2Count": day2Count,
                    "Day2Limit": day2Limit.safeUnwrapAsString()
                ]

            case .acceptedNotifications, .resetedPlan, .extendedPlan, .extendedPlanInLastDay: nil
            case .openedAppStoreFromUpdateActionMenu, .skippedSurveyAndPlanCreating: nil
            }
        }
    }
}
