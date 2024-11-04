//
//  Int+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 04.11.2024.
//

import Foundation

extension Int? {
    func safeUnwrapAsString() -> String {
        self == nil ? "None" : String(describing: self)
    }
}
