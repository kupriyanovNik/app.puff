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
    @Published var questionIndex: Int = 0

//    @AppStorage("surveyAnswers") var surveyAnswersIndices: [Int] = []
    @Published var surveyAnswersIndices: [Int] = []

    func nextScreen() {
        currentIndex += 1
        onboardingPath.append(currentIndex)
    }

    func backToQuestionsFromSkippedView() {
        isSurveySkipped = false

        questionIndex = 7

        while surveyAnswersIndices.count < 7 {
            surveyAnswersIndices.append(0)
        }
    }
}
