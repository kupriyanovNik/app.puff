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
        trimmingCharacters(in: .whitespacesAndNewlines)
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

extension String {
    func formatByDivider(divider: String, count: Int) -> String {
        replacingOccurrences(of: divider, with: String(count))
    }
}
