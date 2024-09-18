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
}
