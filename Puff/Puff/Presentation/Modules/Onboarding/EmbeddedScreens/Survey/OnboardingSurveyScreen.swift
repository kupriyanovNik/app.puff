//
//  OnboardingSurveyScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyScreen: View {

    private let maxIndex: Int = 9

    @State private var isForwardDirection: Bool = true

    @ObservedObject var onboardingVM: OnboardingViewModel

    var questionIndex: Int {
        onboardingVM.questionIndex
    }

    var body: some View {
        VStack(spacing: 24) {
            if !onboardingVM.isSurveySkipped {
                headerView()
                    .transition(.opacity.animation(.smooth))
            }

            if onboardingVM.isSurveySkipped {
                OnboardingSurveySkippedScreen(
                    onboardingVM: onboardingVM,
                    reasonIndex: onboardingVM.surveyAnswersIndices.count > 5 ? onboardingVM.surveyAnswersIndices[5] : nil
                )
                .makeSlideTransition()
            } else {
                if questionIndex <= 5 {
                    questionView(for: OnboardingSurveyScreen.questions[questionIndex])
                        .id(questionIndex)
                        .makeSlideTransition(isForwardDirection: isForwardDirection)
                } else {
                    if questionIndex == 7 {
                        OnboardingSurveyNegativeEffectScreen(
                            onboardingVM: onboardingVM,
                            isForwardDirection: $isForwardDirection
                        )
                        .id(questionIndex)
                        .makeSlideTransition(isForwardDirection: isForwardDirection)
                    } else if questionIndex == 8 {
                        OnboardingSurveySideEffectScreen(
                            onboardingVM: onboardingVM,
                            isForwardDirection: $isForwardDirection
                        )
                        .id(questionIndex)
                        .makeSlideTransition(isForwardDirection: isForwardDirection)
                    }
                }
            }

            Spacer()
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: 12) {
            progressView()

            HStack {
                if questionIndex != 0 && questionIndex != 7 {
                    Button {
                        backQuestion()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(20)
                            .foregroundStyle(
                                Color(hex: 0x0303034D).opacity(0.3)
                            )
                    }
                    .transition(.opacity.animation(.smooth))
                }

                Spacer()

                TextButton(text: "Skip".l) {
                    isForwardDirection = true

                    delay(0.04) {
                        selectAnswer(index: 0)
                    }
                }
                .transition(.opacity.animation(.smooth))
            }
        }
        .padding([.top, .horizontal], 16)
        .prepareForStackPresentation()
    }

    @ViewBuilder
    private func progressView() -> some View {
        let ratio: Double = Double(questionIndex + 1) / Double(maxIndex)

        RoundedRectangle(cornerRadius: 30)
            .fill(Color(hex: 0xE7E7E7))
            .height(6)
            .overlay(alignment: .leading) {
                GeometryReader {
                    let size = $0.size

                    RoundedRectangle(cornerRadius: 30)
                        .fill(Palette.accentColor)
                        .height(6)
                        .width(size.width * ratio)
                        .hLeading()
                }
            }
            .animation(.mainAnimation, value: questionIndex)
    }

    @ViewBuilder
    private func questionView(for question: Question) -> some View {
        VStack(alignment: .center, spacing: 36) {
            MarkdownText(
                text: question.title,
                markdowns: question.markdowns
            )
            .font(.bold28)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(question.answers.indices, id: \.self) { index in
                    answerCell(index, question: question)
                }
            }
            .padding(.horizontal, 12)
        }
    }

    @ViewBuilder
    private func answerCell(_ index: Int, question: Question) -> some View {
        let text = question.answers[index]

        DelayedButton(delayTime: 0.08) {
            isForwardDirection = true

            delay(0.02) {
                selectAnswer(index: index)
            }
        } content: {
            Text(text)
                .font(.semibold16)
                .foregroundStyle(Palette.textPrimary)
                .padding(.vertical, 16)
                .hCenter()
                .background {
                    Color(hex: 0xF0F0F0)
                        .cornerRadius(16)
                }
        }

    }

    private func selectAnswer(index: Int) {
        onboardingVM.surveyAnswersIndices.append(index)

        if (questionIndex == 4 && index == 0) || questionIndex == 5 {
            skipSurvey()
        }

        onboardingVM.questionIndex += 1

        if questionIndex == 9 {
            onboardingVM.nextScreen()
        }
    }

    private func backQuestion() {
        isForwardDirection = false

        delay(0.04) {
            if questionIndex == 7 {
                return
            }

            onboardingVM.questionIndex = max(0, questionIndex - 1)

            if !onboardingVM.surveyAnswersIndices.isEmpty {
                onboardingVM.surveyAnswersIndices.removeLast()
            }
        }
    }

    private func skipSurvey() {
        if questionIndex > 6 {
            onboardingVM.nextScreen()
        } else {
            onboardingVM.isSurveySkipped = true
        }
    }
}

#Preview {
    OnboardingSurveyScreen(onboardingVM: .init())
}


private extension OnboardingSurveyScreen {
    struct Question: Identifiable {
        let id = UUID()
        let title: String
        let markdowns: [String]
        let answers: [String]
    }

    static let questions: [Question] = [
        .init(
            title: "OnboardingSurvey.Question1".l,
            markdowns: ["Как долго", "How long"],
            answers: Array((1...5).map { "OnboardingSurvey.Question1.Answer\($0)".l })
        ),
        .init(
            title: "OnboardingSurvey.Question2".l,
            markdowns: ["больше,", "more"],
            answers: Array((1...2).map { "OnboardingSurvey.Question2.Answer\($0)".l })
        ),
        .init(
            title: "OnboardingSurvey.Question3".l,
            markdowns: ["Как часто", "How often"],
            answers: Array((1...4).map { "OnboardingSurvey.Question3.Answer\($0)".l })
        ),
        .init(
            title: "OnboardingSurvey.Question4".l,
            markdowns: ["ваше утро", "your morning"],
            answers: Array((1...3).map { "OnboardingSurvey.Question4.Answer\($0)".l })
        ),
        .init(
            title: "OnboardingSurvey.Question5".l,
            markdowns: ["уже пробовали", "Have you tried"],
            answers: Array((1...3).map { "OnboardingSurvey.Question5.Answer\($0)".l })
        ),
        .init(
            title: "OnboardingSurvey.Question6".l,
            markdowns: ["основной", "main"],
            answers: Array((1...4).map { "OnboardingSurvey.Question6.Answer\($0)".l })
        )
    ]
}
