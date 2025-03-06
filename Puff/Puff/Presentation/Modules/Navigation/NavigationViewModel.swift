//
//  NavigationViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import Foundation
import SwiftUI

final class NavigationViewModel: ObservableObject {
    @Published var selectedTab: TabBarModel = .home

    @Published var appNavigationPath = NavigationPath()

    @Published var shouldShowWidgetsTip: Bool = false
    @AppStorage("hasSeenWidgetsTip") var hasSeenWidgetsTip: Bool = false

    @Published var shouldShowPlanDevelopingActionMenu: Bool = false
    @Published var shouldShowReadyToBreakActionMenu: Bool = false
    @Published var shouldShowAddingMoreSmokesActionMenu: Bool = false

    @Published var tappedReadyToBreak: Bool = false

    @Published var shouldShowPlanExtendingActionMenu: Bool = false
    @Published var shouldShowYesterdayResult: Bool = false
    @AppStorage("dateOfSeenYesterdayResult") private(set) var dateOfSeenYesterdayResult: Date?
    @Published private(set) var ableToShowYesterdayResult: Bool = false

    @Published var shouldShowUpdateActionMenu: Bool = false
    @AppStorage("dateOfSeenUpdateSheet") private(set) var dateOfSeenUpdateSheet: Date?
    @Published private(set) var ableToShowUpdateActionMenu: Bool = false

    @Published var shouldShowDailyPaywall: Bool = false
    @AppStorage("dateOfSeenDailyPaywall") private(set) var dateOfSeenDailyPaywall: Date?
    @Published private(set) var ableToShowDailyPaywall: Bool = false

    @Published var shouldShowHomePaywall: Bool = false
    @Published var shouldShowStatisticsPaywall: Bool = false
    @Published var shouldShowOnboardingPaywall: Bool = false

    init() {
        checkAbilityToShowYesterdayResult()
        checkAbilityToShowUpdateActionMenu()
        checkAbilityToShowDailyPaywall()
    }

    func seenYesterdayResult() {
        dateOfSeenYesterdayResult = .now

        shouldShowPlanExtendingActionMenu = false
        shouldShowYesterdayResult = false

        checkAbilityToShowYesterdayResult()
    }

    func seenUpdateActionMenu() {
        dateOfSeenUpdateSheet = .now
        ableToShowUpdateActionMenu = false
        shouldShowUpdateActionMenu = false
    }

    func seenDailyPaywall() {
        dateOfSeenDailyPaywall = .now
        ableToShowDailyPaywall = false
    }

    func checkAbilityToShowYesterdayResult() {
        if let dateOfSeenYesterdayResult {
            ableToShowYesterdayResult = !Calendar.current.isDateInToday(dateOfSeenYesterdayResult)
        } else {
            ableToShowYesterdayResult = true
        }
    }

    func checkAbilityToShowDailyPaywall() {
        if let dateOfSeenDailyPaywall {
            ableToShowDailyPaywall = !Calendar.current.isDateInToday(dateOfSeenDailyPaywall)
        }
    }

    private func checkAbilityToShowUpdateActionMenu() {
        if let dateOfSeenUpdateSheet {
            if TimeInterval(Date() - dateOfSeenUpdateSheet) / 86400 < 3 {
                ableToShowUpdateActionMenu = false
            } else {
                ableToShowUpdateActionMenu = true
            }
        } else {
            ableToShowUpdateActionMenu = true
        }
    }
}

enum AppNavigationPathValue {
    static let account = "ACCOUNTVIEW"
    static let accountWidgetsInfo = "ACCOUNTWIDGETSINFOVIEW"
    static let accountWidgetsInfoHomeScreen = "ACCOUNTWIDGETSINFOVIEWHomeScreen"
    static let accountWidgetsInfoControlCenter = "ACCOUNTWIDGETSINFOVIEWControlCenter"
    static let accountWidgetsInfoActionButton = "ACCOUNTWIDGETSINFOVIEWActionButton"
    static let accountWidgetsInfoDoubleTap = "ACCOUNTWIDGETSINFOVIEWDoubleTap"
    static let accountWidgetsInfoLockScreen = "ACCOUNTWIDGETSINFOVIEWLockScreen"
    static let accountSubscriptionInfo = "ACCOUNTSUBSCRIPTIONINFOVIEW"
}

extension NavigationViewModel {
    func back() {
        appNavigationPath.removeLast()
    }

    func showAccount() {
        appNavigationPath.append(AppNavigationPathValue.account)
    }

    func showSubscriptionInfo() {
        appNavigationPath.append(AppNavigationPathValue.accountSubscriptionInfo)
    }

    func showWidgetsInfo() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfo)
    }

    func showAccountWidgetsHomeInfo() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfoHomeScreen)
    }

    func showAccountWidgetsControlCenter() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfoControlCenter)
    }

    func showAccountWidgetsActionButton() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfoActionButton)
    }

    func showAccountWidgetsDoubleTap() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfoDoubleTap)
    }

    func showAccountWidgetsLockScreen() {
        appNavigationPath.append(AppNavigationPathValue.accountWidgetsInfoLockScreen)
    }
}
