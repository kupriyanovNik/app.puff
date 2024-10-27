//
//  PuffWidgetProviderModel.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 27.10.2024.
//

import WidgetKit

// MARK: - Model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
    var limit: Int?
    let isEnded: Bool
    let dateOfLastSmoke: Int
}
