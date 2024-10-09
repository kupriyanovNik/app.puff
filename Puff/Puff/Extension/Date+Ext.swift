//
//  Date+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
    }
}

extension Date: RawRepresentable {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    public var rawValue: String {
        Date.dateFormatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.dateFormatter.date(from: rawValue) ?? Date()
    }
}

extension Date {
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? .now
    }

    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self) ?? .now
    }
}
