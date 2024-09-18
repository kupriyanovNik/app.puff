//
//  AppManager.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

final class AppManager: ObservableObject {
    @AppStorage("appOpensCount") var appOpensCount: Int = 0

    init() {
        self.appOpensCount += 1
    }

    func reset() {
        appOpensCount = 0
    }
}
