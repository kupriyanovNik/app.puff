//
//  TabBarModel.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import Foundation

enum TabBarModel: CaseIterable {
    case home, statistics

    var selectedImageName: String {
        switch self {
        case .home: ""
        case .statistics: ""
        }
    }

    var defaultImageName: String {
        switch self {
        case .home: ""
        case .statistics: ""
        }
    }
}
