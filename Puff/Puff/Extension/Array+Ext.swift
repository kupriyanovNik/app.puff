//
//  Array+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Array {
    func safeIndex(_ index: Int) -> Element {
        self[Swift.min(Swift.max(0, index), self.count - 1)]
    }
}
