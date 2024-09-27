//
//  StatusBarWrapperView.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import SwiftUI

struct StatusBarWrapperView<Content: View>: View {

    var content: () -> Content

    @State private var statusBarWindow: UIWindow?

    var body: some View {
        content()
            .onAppear {
                if self.statusBarWindow == nil {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let statusBarWindow = UIWindow(windowScene: windowScene)
                        statusBarWindow.windowLevel = .statusBar
                        statusBarWindow.tag = 0329
                        let controller = StatusBarWrapperViewController()
                        controller.view.backgroundColor = .clear
                        controller.view.isUserInteractionEnabled = false
                        statusBarWindow.rootViewController = controller
                        statusBarWindow.isHidden = false
                        statusBarWindow.isUserInteractionEnabled = false
                        self.statusBarWindow = statusBarWindow
                    }
                }
            }
    }
}

#Preview {
    StatusBarWrapperView {
        Text("A")
    }
}

class StatusBarWrapperViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
}
