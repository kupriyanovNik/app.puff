//
//  OnboardingViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    private var currentIndex: Int = 0

    @Published var onboardingPath = NavigationPath()
    @Published var isSurveySkipped: Bool = false

    @AppStorage("surveyAnswers") var surveyAnswersIndices: [Int] = []

    func nextScreen() {
        currentIndex += 1
        onboardingPath.append(currentIndex)
    }
}
