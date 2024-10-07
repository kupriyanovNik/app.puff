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
        case .home: "tabBarHomeSelectedImage"
        case .statistics: "tabBarStatisticsSelectedImage"
        }
    }

    var defaultImageName: String {
        switch self {
        case .home: "tabBarHomeDefaultImage"
        case .statistics: "tabBarStatisticsDefaultImage"
        }
    }

    var title: String {
        switch self {
        case .home: "TabBar.Home".l
        case .statistics: "TabBar.Progress".l
        }
    }
}
