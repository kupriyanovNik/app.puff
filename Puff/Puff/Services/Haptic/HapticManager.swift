//
//  HapticManager.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import UIKit

/// Класс, позволяющий взаимодействовать с вибромотором устройства
final class HapticManager {

    /// Функция, воспроизводящая вибрацию телефона
    ///
    /// - Parameters:
    ///     - style: тип вибрации
    ///     - intensity: интенсивность вибрации
    static func feedback(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        intensity: Double = 1
    ) {
        UIImpactFeedbackGenerator(style: style)
            .impactOccurred(intensity: intensity)
    }

    static func onTabChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func onTappedPlus() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func actionMenusButton() {
        if #available(iOS 17.5, *) {
            UIImpactFeedbackGenerator(style: .rigid)
                .impactOccurred(
                    intensity: 1, at: .init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height)
                )
        } else {
            UIImpactFeedbackGenerator(style: .rigid)
                .impactOccurred(intensity: 0.5)
        }
    }
}
