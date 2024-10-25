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
    var startOfDate: Date {
        Calendar.current.startOfDay(for: self)
    }

    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? .now
    }

    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self) ?? .now
    }

    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        return calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) ?? .now
    }

    var endOfWeek: Date {
        let calendar = Calendar.current

        return calendar.date(byAdding: .day, value: 6, to: self.startOfWeek) ?? .now
    }

    var endOfMonth: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth) ?? .now
    }

    var startOfMonth: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components) ?? .now
    }
}
