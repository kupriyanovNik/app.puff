//
//  StatisticsFrequencyViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

final class StatisticsFrequencyViewModel: ObservableObject {
    @AppStorage("smokesHours") var smokesHours: [Int] = Array(repeating: 0, count: 24)

    private var hasSmoked: Bool {
        smokesHours.filter { $0 == 0 }.count != smokesHours.count
    }
}
