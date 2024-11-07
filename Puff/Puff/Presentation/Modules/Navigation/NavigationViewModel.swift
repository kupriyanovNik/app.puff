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

    @Published var shouldShowPaywall: Bool = false

    @Published var shouldShowPlanDevelopingActionMenu: Bool = false
    @Published var shouldShowReadyToBreakActionMenu: Bool = false
    @Published var shouldShowAddingMoreSmokesActionMenu: Bool = false

    @Published var shouldShowPlanExtendingActionMenu: Bool = false
    @Published var shouldShowYesterdayResult: Bool = false

    @Published var tappedReadyToBreak: Bool = false

    @AppStorage("dateOfSeenYesterdayResult") private(set) var dateOfSeenYesterdayResult: Date?
    @Published private(set) var ableToShowYesterdayResult: Bool = false

    init() {
        checkAbilityToShowYesterdayResult()
    }

    private func checkAbilityToShowYesterdayResult() {
        if let dateOfSeenYesterdayResult {
            ableToShowYesterdayResult = !Calendar.current.isDateInToday(dateOfSeenYesterdayResult)
        } else {
            ableToShowYesterdayResult = true
        }
    }

    func seenYesterdayResult() {
        dateOfSeenYesterdayResult = .now

        shouldShowPlanExtendingActionMenu = false
        shouldShowYesterdayResult = false

        checkAbilityToShowYesterdayResult()
    }
}
