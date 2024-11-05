//
//  View+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

extension View {

    // MARK: - Horizontal Alignment

    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    func hTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    // MARK: - Vertical Alignment

    func vTop() -> some View {
        frame(maxHeight: .infinity, alignment: .top)
    }

    func vCenter() -> some View {
        frame(maxHeight: .infinity, alignment: .center)
    }

    func vBottom() -> some View {
        frame(maxHeight: .infinity, alignment: .bottom)
    }

    // MARK: - Frame Layout

    func frame(_ value: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: value, height: value, alignment: alignment)
    }

    func height(_ height: CGFloat, alignment: Alignment = .center) -> some View {
        frame(height: height, alignment: alignment)
    }

    func width(_ width: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: width, alignment: alignment)
    }
}

extension View {
    func onTapEndEditing() -> some View {
        onTapGesture {
            hideKeyboard()
        }
    }

    func onTapContinueEditing() -> some View {
        onTapGesture { }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}

extension View {
    func roundedCornerWithBorder(
        lineWidth: CGFloat = 1,
        borderColor: Color,
        radius: CGFloat = 16,
        corners: UIRectCorner
    ) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
            .overlay(
                RoundedCorner(radius: radius, corners: corners)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func prepareForStackPresentation() -> some View {
        self
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
    }
}


extension View {
    func makeSlideTransition() -> some View {
        self
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ).animation(.mainAnimation)
            )
            .animation(.mainAnimation)
    }

    func makeSlideTransition(isForwardDirection: Bool) -> some View {
        self
            .transition(
                .asymmetric(
                    insertion: .move(edge: isForwardDirection ? .trailing : .leading) ,
                    removal: .move(edge: isForwardDirection ? .leading : .trailing)
                ).animation(.mainAnimation)
            )
            .animation(.mainAnimation)
    }

    func makeCustomConditionalView<Content: View>(
        _ condition: Bool,
        transition: AnyTransition = .opacity.combined(with: .offset(y: 50)).animation(.mainAnimation),
        content: @escaping () -> Content
    ) -> some View {
        overlay {
            Group {
                if condition {
                    content()
                    .preferredColorScheme(.light)
                    .transition(transition)
                }
            }
            .animation(.mainAnimation, value: condition)
        }
    }
}

extension View {
    var isSmallDevice: Bool { UIScreen.main.bounds.height < 700 }
}
