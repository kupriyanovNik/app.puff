//
//  UINavigationController+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 05.11.2024.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()

        let actionString = ["handle", "Navigation", "Transition", ":"].joined()
        let action = Selector(actionString)
        let panGesture = UIPanGestureRecognizer(
            target: self.interactivePopGestureRecognizer?.delegate,
            action: action
        )

        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)

        self.interactivePopGestureRecognizer?.isEnabled = false
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if NavigationState.shared.swipeEnabled {
            return viewControllers.count > 1
        }

        return false
    }

}

class NavigationState {
    static let shared = NavigationState()

    private init() {}

    var swipeEnabled = true
}
