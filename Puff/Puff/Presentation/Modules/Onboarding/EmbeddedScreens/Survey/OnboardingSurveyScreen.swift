//
//  OnboardingSurveyScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyScreen: View {

    @State private var questionIndex: Int = 0

    private let maxIndex: Int = 10

    @ObservedObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            headerView()


            if questionIndex == 0 {
                questionView(for: OnboardingSurveyScreen.questions[0])
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ).animation(.smooth)
                    )
            } else if questionIndex == 1 {
                questionView(for: OnboardingSurveyScreen.questions[1])
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ).animation(.smooth)
                    )
            } else if questionIndex == 2 {
                questionView(for: OnboardingSurveyScreen.questions[2])
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ).animation(.smooth)
                    )
            } else if questionIndex == 3 {
                questionView(for: OnboardingSurveyScreen.questions[3])
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ).animation(.smooth)
                    )
            } else if questionIndex == 4 {
                questionView(for: OnboardingSurveyScreen.questions[4])
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ).animation(.smooth)
                    )
            }

            Spacer()
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: 12) {
            progressView()

            HStack {
                if questionIndex != 0 {
                    Button {
                        questionIndex = max(0, questionIndex - 1)
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

                TextButton(text: "Пропустить", action: skipSurvey)
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
            .animation(.smooth, value: questionIndex)
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

        DelayedButton {
            selectAnswer(index: index)
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

        questionIndex += 1
    }

    private func backQuestion() {
        questionIndex = max(0, questionIndex - 1)

        onboardingVM.surveyAnswersIndices = onboardingVM.surveyAnswersIndices.dropLast()
    }

    private func skipSurvey() {
        onboardingVM.isSurveySkipped = true
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
        )
    ]
}
