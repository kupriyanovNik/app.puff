//
//  PuffApp.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

@main
struct PuffApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
