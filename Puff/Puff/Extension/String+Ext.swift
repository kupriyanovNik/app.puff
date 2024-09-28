//
//  String+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import Foundation
import UIKit

extension String {
    func removeExtraSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String {
    func openURL() {
        if let url = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
