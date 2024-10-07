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

    @Published var shouldShowAccountView: Bool = false

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

    @Published var shouldShowPaywall: Bool = false
    @AppStorage("dateOfSeenDailyPaywall") private(set) var dateOfSeenDailyPaywall: Date?
    @Published private(set) var ableToShowDailyPaywall: Bool = false

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
            }
        } else {
            ableToShowUpdateActionMenu = true
        }
    }
}
