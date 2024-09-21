//
//  Fonts.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

extension Font {
    static let bold108 = getBold(size: 108)
    static let bold28 = getBold(size: 28)
    static let bold22 = getBold(size: 22)
    static let bold18 = getBold(size: 18)

    static let semibold22 = getSemibold(size: 22)
    static let semibold18 = getSemibold(size: 18)
    static let semibold16 = getSemibold(size: 16)
    static let semibold15 = getSemibold(size: 15)
    static let semibold14 = getSemibold(size: 14)

    static let medium24 = getMedium(size: 24)
    static let medium16 = getMedium(size: 16)
    static let medium15 = getMedium(size: 15)
    static let medium12 = getMedium(size: 12)
}

extension UIFont {
    static let medium15: UIFont = .init(name: "SF Pro Rounded Medium", size: 15)!
}

private extension Font {
    static func getRegular(size: CGFloat) -> Font {
        .custom("SF Pro Rounded Regular", size: size)
    }

    static func getMedium(size: CGFloat) -> Font {
        .custom("SF Pro Rounded Medium", size: size)
    }

    static func getSemibold(size: CGFloat) -> Font {
        .custom("SF Pro Rounded Semibold", size: size)
    }

    static func getBold(size: CGFloat) -> Font {
        .custom("SF Pro Rounded Bold", size: size)
    }
}
