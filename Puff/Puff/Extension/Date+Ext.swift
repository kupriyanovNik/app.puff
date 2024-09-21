//
//  Date+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
