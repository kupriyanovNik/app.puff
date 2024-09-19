//
//  String+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import Foundation

extension String {
    func removeExtraSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
