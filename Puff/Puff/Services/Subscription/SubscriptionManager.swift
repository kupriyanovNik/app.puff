//
//  SubscriptionManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import Foundation

final class SubscriptionManager {
    static let shared = SubscriptionManager()

    private init() { }

    var isPremium: Bool = false
}
