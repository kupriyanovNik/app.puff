//
//  PuffWidgetView.swift
//  PuffWidgetView
//
//  Created by Никита Куприянов on 14.10.2024.
//

import WidgetKit
import SwiftUI

struct PuffWidgetsEntryView : View {

    @Environment(\.colorScheme) var colorScheme

    var entry: PuffWidgetProvider.Entry

    private var buttonColor: Color {
        Color(hex: 0xB5D9FF, alpha: colorScheme == .light ? 1 : 0.92)
    }

    private var text: String {
        if let limit = entry.limit {
            return "\(entry.count)/\(limit)"
        }

        return "\(entry.count)"
    }

    private var daysDontSmoke: Int {
        Int( (Double(Date().timeIntervalSince1970) - Double(entry.dateOfLastSmoke)) / 86400 )
    }

    var body: some View {
        Group {
            if entry.isEnded {
                planEndedView()
            } else {
                VStack(spacing: 12) {
                    Text(text) { str in
                        if let limit = entry.limit {
                            if let range = str.range(of: "/\(limit)") {
                                str[range].foregroundColor = .limit
                            }
                        }
                    }
                    .id(entry.count)
                    .font(.bold26)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 1.035),
                            removal: .identity
                        )
                    )

                    button()
                }
            }
        }
    }

    @ViewBuilder
    private func button() -> some View {
        Button(intent: PuffIntent()) {
            RoundedRectangle(cornerRadius: 16)
                .fill(buttonColor)
                .overlay {
                    Image(.puffWidgetPlus)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                }
        }
        .buttonStyle(PuffWidgetButtonStyle())
    }

    @ViewBuilder
    private func planEndedView() -> some View {
        Image(.planEndedBackground)
            .scaledToFill()
            .ignoresSafeArea()
            .scaleEffect(1.2)
            .overlay {
                VStack(spacing: 4) {
                    Text(daysDontSmoke == 0 ? "Widgets.Broke".l : "Home.DontSmokeFor".l)
                        .font(.medium15)
                        .foregroundStyle(.limit)

                    Text(getTime())
                        .font(.bold28)
                        .foregroundStyle(.dontSmoke)
                        .multilineTextAlignment(.center)
                }
            }
    }
}

// MARK: - Puff Widget Button Style
private extension PuffWidgetsEntryView {
    struct PuffWidgetButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            let isPressed = configuration.isPressed

            configuration.label
                .opacity(isPressed ? 0.8 : 1)
                .animation(.easeOut(duration: 0.15), value: isPressed)
        }
    }
}

// MARK: - Plan Ended Date Calculation
private extension PuffWidgetsEntryView {
    private func getTime() -> String {
        if entry.dateOfLastSmoke > 0 {
            return getLastSmokeTimeString(for: entry.dateOfLastSmoke)
        } else {
            return "Home.RealyLongTime".l
        }
    }

    private func getLastSmokeTimeString(for dateInt: Int) -> String {
        let diff = Double(Date().timeIntervalSince1970) - Double(dateInt)
        let days = Int(diff / 86400)

        if Bundle.main.preferredLocalizations[0] == "ru" {
            return getLastSmokeTimeRussianString(days)
        } else {
            return getLastSmokeTimeEnglishString(days)
        }
    }

    private func getLastSmokeTimeEnglishString(_ days: Int) -> String {
        if days > 0 {
//            if days > 30 {
//                return "More then month"
//            }

            if days == 1 {
                return "1 day"
            } else {
                return "\(days) days"
            }
        }

        return "Today"
    }

    private func getLastSmokeTimeRussianString(_ days: Int) -> String {
        if days > 0 {
//            if days > 30 {
//                return "Больше месяца"
//            }

            if days % 10 == 1 && days % 100 != 11 {
                return "\(days) день"
            } else if (days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14) {
                return "\(days) дня"
            } else {
                return "\(days) дней"
            }
        }

        return "Сегодня"
    }
}
