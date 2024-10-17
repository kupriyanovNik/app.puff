//
//  CustomSheet.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct CustomSheet<Content: View>: View {

    @Binding var isPresented: Bool

    var ableToDismissWithSwipe: Bool
    var cornerRadius: Double
    var topPadding: Double

    var onDismiss: () -> Void
    var content: () -> Content

    @State private var offset: Double = .zero

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if ableToDismissWithSwipe {
                    self.offset = value.translation.height
                }
            }
            .onEnded { value in
                if ableToDismissWithSwipe {
                    if value.translation.height > 100 {
                        isPresented = false
                        onDismiss()

                        delay(0.4) {
                            offset = .zero
                        }
                    } else {
                        withAnimation(.easeOut(duration: 0.25)) {
                            offset = .zero
                        }
                    }
                }
            }
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
                .opacity(isPresented ? 1 : 0)
                .animation(.easeOut(duration: 0.25), value: isPresented)
                .onTapGesture {
                    if ableToDismissWithSwipe {
                        isPresented = false
                        onDismiss()
                    }
                }

            VStack {
                Spacer()

                Group {
                    if isPresented {
                        content()
                            .padding(.top, topPadding)
                            .background {
                                Color.white
                                    .overlay(alignment: .top) {
                                        if ableToDismissWithSwipe {
                                            Capsule()
                                                .fill(Palette.textTertiary)
                                                .frame(width: 56, height: 4)
                                                .padding(.top, 10)
                                        }
                                    }
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: cornerRadius,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 0,
                                            topTrailingRadius: cornerRadius
                                        )
                                    )
                                    .ignoresSafeArea()
                            }
                            .transition(.move(edge: .bottom).animation(.easeInOut(duration: 0.25)))
                    }
                }
                .animation(.easeOut(duration: 0.25), value: isPresented)
                .offset(y: ableToDismissWithSwipe ? max(0, offset) : 0)
                .gesture(gesture)
            }
        }
    }
}

extension View {
    func makeCustomSheet(
        isPresented: Binding<Bool>,
        ableToDismissWithSwipe: Bool = true,
        cornerRadius: Double = 20,
        topPadding: Double = 16,
        content: @escaping () -> some View,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        overlay {
            CustomSheet(
                isPresented: isPresented,
                ableToDismissWithSwipe: ableToDismissWithSwipe,
                cornerRadius: cornerRadius,
                topPadding: topPadding,
                onDismiss: onDismiss,
                content: content
            )
        }
    }
}
