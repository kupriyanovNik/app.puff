//
//  ActionMenuPlanDevelopingModel.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import Foundation

enum ActionMenuPlanDevelopingPeriod: Int, CaseIterable {
    case min = 7
    case mid = 21
    case max = 30


    var title: String {
        switch self {
        case .min:
            "\(self.rawValue) дней"
        case .mid:
            "\(self.rawValue) дней"
        case .max:
            "\(self.rawValue) дней"
        }
    }

    var subtitle: String {
        switch self {
        case .min:
            "Самый быстрый"
        case .mid:
            "Золотая середина"
        case .max:
            "Самый плавный"
        }
    }

    var description: String {
        switch self {
        case .min:
            "Ощутимое снижение лимита затяжек. Для тех, кто хочет и готов бросить в кратчайший срок"
        case .mid:
            "Оптимальный темп снижения лимита затяжек. Для тех, кто ищет баланс между скоростью бросания и комфортом"
        case .max:
            "Почти незаметное снижение лимита затяжек. Для тех, кто не спешит и хочет бросить без ощущения ограничений"
        }
    }
}
