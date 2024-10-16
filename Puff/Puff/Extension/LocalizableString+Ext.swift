//
//  LocalizableString+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import Foundation

public extension String {
    public var l: String {
        NSLocalizedString(self, comment: "")
    }
}
