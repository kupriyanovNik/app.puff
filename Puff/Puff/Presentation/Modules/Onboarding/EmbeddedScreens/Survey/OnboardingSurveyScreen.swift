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
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: isForwardDirection ? .trailing : .leading) ,
                                removal: .move(edge: isForwardDirection ? .leading : .trailing)
                            ).animation(.easeInOut(duration: 0.3))
                        )
                        .animation(.easeInOut(duration: 0.3))
                } else {
                    if questionIndex == 7 {
                        OnboardingSurveyNegativeEffectScreen(
                            onboardingVM: onboardingVM,
                            isForwardDirection: $isForwardDirection
                        )
                        .id(questionIndex)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: isForwardDirection ? .trailing : .leading) ,
                                removal: .move(edge: isForwardDirection ? .leading : .trailing)
                            ).animation(.easeInOut(duration: 0.3))
                        )
                        .animation(.easeInOut(duration: 0.3))
                    } else if questionIndex == 8 {
                        OnboardingSurveySideEffectScreen(
                            onboardingVM: onboardingVM,
                            isForwardDirection: $isForwardDirection
                        )
                        .id(questionIndex)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: isForwardDirection ? .trailing : .leading) ,
                                removal: .move(edge: isForwardDirection ? .leading : .trailing)
                            ).animation(.easeInOut(duration: 0.3))
                        )
                        .animation(.easeInOut(duration: 0.3))
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

                TextButton(text: "Пропустить") {
                    isForwardDirection = true

                    delay(0.04) {
                        selectAnswer(index: 0)
                    }
                }
                .transition(.opacity.animation(.smooth))
            }
        }
        .padding([.top, .horizontal], 16)
        .prepareForStackPresentationInOnboarding()
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
            .animation(.easeInOut(duration: 0.3), value: questionIndex)
    }

    @ViewBuilder
    private func questionView(for question: Question) -> some View {
        VStack(alignment: .center, spacing: 36) {
            MarkdownText(
                text: question.title,
                markdown: question.markdown
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
            selectAnswer(index: index)
        } actionWithoutDelay: {
            isForwardDirection = true
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
        let markdown: String
        let answers: [String]
    }

    static let questions: [Question] = [
        .init(
            title: "Как долго вы уже парите?",
            markdown: "Как долго",
            answers: [
                "Менее 1 месяца",
                "1-6 месяцев",
                "6-12 месяцев",
                "1-2 года",
                "Более 2 лет"
            ]
        ),
        .init(
            title: "Парите ли вы сейчас больше, чем когда начинали?",
            markdown: "больше,",
            answers: [
                "Да", "Нет"
            ]
        ),
        .init(
            title: "Как часто вы парите?",
            markdown: "Как часто",
            answers: [
                "Редко",
                "Довольно часто",
                "Постоянно",
                "Не выпускаю из рук"
            ]
        ),
        .init(
            title: "Часто ли ваше утро начинается с желания попарить?",
            markdown: "ваше утро",
            answers: [
                "Нет, никогда",
                "Да, иногда",
                "Да, постоянно"
            ]
        ),
        .init(
            title: "Вы уже пробовали бросить парить?",
            markdown: "уже пробовали",
            answers: [
                "Нет",
                "Да, 1-2 раза",
                "Да, много раз"
            ]
        ),
        .init(
            title: "Что было основной причиной срыва?",
            markdown: "основной",
            answers: [
                "Ломка",
                "Стресс",
                "Влияние окружающих",
                "Не знаю"
            ]
        )
    ]
}
