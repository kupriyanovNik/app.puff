//
//  NavigationViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import Foundation

final class NavigationViewModel: ObservableObject {
    @Published var selectedTab: TabBarModel = .home
}
