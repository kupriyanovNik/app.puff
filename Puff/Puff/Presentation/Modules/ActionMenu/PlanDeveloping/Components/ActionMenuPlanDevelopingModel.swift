//
//  ActionMenuPlanDevelopingModel.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import Foundation

enum ActionMenuPlanDevelopingPeriod: Int, CaseIterable {
    case min = 7
    case mid = 21
    case max = 30


    var title: String {
        if Bundle.main.preferredLocalizations[0] == "ru" {
            switch self {
            case .min:
                return "\(self.rawValue) дней"
            case .mid:
                return "\(self.rawValue) день"
            case .max:
                return "\(self.rawValue) дней"
            }
        }

        return "\(self.rawValue) days"
    }

    var subtitle: String {
        switch self {
        case .min:
            "ActionMenuPlanDeveloping.Plan.Plan1Title".l
        case .mid:
            "ActionMenuPlanDeveloping.Plan.Plan2Title".l
        case .max:
            "ActionMenuPlanDeveloping.Plan.Plan3Title".l
        }
    }

    var description: String {
        switch self {
        case .min:
            "ActionMenuPlanDeveloping.Plan.Plan1Description".l
        case .mid:
            "ActionMenuPlanDeveloping.Plan.Plan2Description".l
        case .max:
            "ActionMenuPlanDeveloping.Plan.Plan3Description".l
        }
    }
}
