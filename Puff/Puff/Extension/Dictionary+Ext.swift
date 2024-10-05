//
//  Dictionary+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import Foundation

extension Dictionary: RawRepresentable where Key == Date, Value == Int {
    public init?(rawValue: String) {
        let jsonDecoder = JSONDecoder()

        guard let data = rawValue.data(using: .utf8),
              let result = try? jsonDecoder.decode([Date : Int].self, from: data)
        else {
            return nil
        }

        self = result
    }

    public var rawValue: String {
        let jsonEncoder = JSONEncoder()

        guard let data = try? jsonEncoder.encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return result
    }

}
