//
//  LottieView.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI
import UIKit
import Lottie

struct LottieView: UIViewRepresentable {

    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var delay: Double = 0.5

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode

        Puff.delay(self.delay) {
            animationView.play()
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
