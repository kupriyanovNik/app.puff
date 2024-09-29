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
}

#Preview {
    ActionMenuYesterdayPlanExceededView(todayLimit: 1000, yesterdedExceed: 12) {

    } onDismiss: {

    }
}
