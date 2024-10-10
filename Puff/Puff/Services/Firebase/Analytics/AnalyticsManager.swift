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
    }

    enum AnalyticsEvent {
        case openedPaywall(tab: Int)
        case seenOnboarding(pageNumber: Int)
        case answeredOnboardingQuestion(questionNumber: Int, answers: [String])
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
            case .openedPaywall: "OpenedPaywall"
            case .seenOnboarding: "SeenOnboarding"
            case .answeredOnboardingQuestion: "answeredOnboardingQuestion"
            case .acceptedNotifications: "AcceptedNotifications"
            case .resetedPlan: "ResetedPlan"
            case .canceledSubscription: "CanceledSubscription"
            case .startedPlan: "StartedPlan"
            case .addedMoreSmokes: "AddedMoreSmokes"
            case .extendedPlan: "ExtendedPlan"
            case .extendedPlanInLastDay: "ExtendedPlanInLastDay"
            case .openedAppStoreFromUpdateActionMenu: "OpenedAppStoreFromUpdateActionMenu"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .openedPaywall(let tab):
                ["FromTab": tab]

            case .seenOnboarding(let pageNumber):
                ["PageNumber": pageNumber]

            case .answeredOnboardingQuestion(let questionNumber, let answers):
                ["QuestionNumber": questionNumber, "Answers": answers.joined(separator: ";")]

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
