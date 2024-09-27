//
//  ActionMenuYesterdayPlanExceededView.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuYesterdayPlanExceededView: View {

    var todayLimit: Int
    var yesterdedExceed: Int

    var onExtendPlan: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        Text("Hello, World!")
    }

    private func formatText(text: String, date: Date) -> [String]? {
        guard
            let range = text.range(of: "{smokesCount}")
        else { return nil }

        let startPosition = text.distance(from: text.startIndex, to: range.lowerBound)
        let endPosition = text.distance(from: text.startIndex, to: range.upperBound)

        let start = text[0..<startPosition]
        let end = text[endPosition..<text.count]

        return [start, end]
    }
}

#Preview {
    ActionMenuYesterdayPlanExceededView(todayLimit: 1000, yesterdedExceed: 12) {

    } onDismiss: {

    }
}
