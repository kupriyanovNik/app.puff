//
//  UIApplication+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import UIKit
import SwiftUI

extension UIApplication {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBarWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows
            .first(
                where: { $0.tag == 0320 }
            ), let statusBarController = statusBarWindow.rootViewController as? StatusBarWrapperViewController {
            statusBarController.statusBarStyle = style
            statusBarController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
