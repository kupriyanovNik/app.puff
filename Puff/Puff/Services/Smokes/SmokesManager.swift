//
//  SmokesManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import Foundation
import SwiftUI

final class SmokesManager: ObservableObject {
    @AppStorage("isPlanCreated") var isPlanCreated: Bool = false

    @AppStorage("currentDayIndex") var currentDayIndex: Int = 0
}
