////
////  RippleEffectModifier.swift
////  Puff
////
////  Created by Никита Куприянов on 29.09.2024.
////
//import SwiftUI
//
//struct RippleEffect<T: Equatable>: ViewModifier {
//    var origin: CGPoint
//
//    var trigger: T
//
//    init(at origin: CGPoint, trigger: T) {
//        self.origin = origin
//        self.trigger = trigger
//    }
//
//    func body(content: Content) -> some View {
//        let origin = origin
//        let duration = duration
//
//        if #available(iOS 18.0, *) {
//            content.keyframeAnimator(
//                initialValue: 0,
//                trigger: trigger
//            ) { view, elapsedTime in
//                view.modifier(RippleModifier(
//                    origin: origin,
//                    elapsedTime: elapsedTime,
//                    duration: duration
//                ))
//            } keyframes: { _ in
//                MoveKeyframe(0)
//                LinearKeyframe(duration, duration: duration)
//            }
//        } else {
//            content
//        }
//    }
//
//    var duration: TimeInterval { 3 }
//}
//
//@available(iOS 18.0, *)
//struct RippleModifier: ViewModifier {
//    var origin: CGPoint
//
//    var elapsedTime: TimeInterval
//
//    var duration: TimeInterval
//
//    var amplitude: Double = 12
//    var frequency: Double = 15
//    var decay: Double = 8
//    var speed: Double = 2000
//
//    func body(content: Content) -> some View {
//        let shader = ShaderLibrary.Ripple(
//            .float2(origin),
//            .float(elapsedTime),
//
//            // Parameters
//            .float(amplitude),
//            .float(frequency),
//            .float(decay),
//            .float(speed)
//        )
//
//        let maxSampleOffset = maxSampleOffset
//        let elapsedTime = elapsedTime
//        let duration = duration
//
//        content.visualEffect { view, _ in
//            view.layerEffect(
//                shader,
//                maxSampleOffset: maxSampleOffset,
//                isEnabled: 0 < elapsedTime && elapsedTime < duration
//            )
//        }
//    }
//
//    var maxSampleOffset: CGSize {
//        CGSize(width: amplitude, height: amplitude)
//    }
//}
//
//extension View {
//    @available(iOS 18.0, *)
//    func onPressingChanged(_ action: @escaping (CGPoint?) -> Void) -> some View {
//        modifier(SpatialPressingGestureModifier(action: action))
//    }
//}
//
//@available(iOS 18.0, *)
//struct SpatialPressingGestureModifier: ViewModifier {
//    var onPressingChanged: (CGPoint?) -> Void
//
//    @State var currentLocation: CGPoint?
//
//    init(action: @escaping (CGPoint?) -> Void) {
//        self.onPressingChanged = action
//    }
//
//    func body(content: Content) -> some View {
//        let gesture = SpatialPressingGesture(location: $currentLocation)
//
//        content
//            .gesture(gesture)
//            .onChange(of: currentLocation, initial: false) { _, location in
//                onPressingChanged(location)
//            }
//    }
//}
//
//@available(iOS 18.0, *)
//struct SpatialPressingGesture: UIGestureRecognizerRepresentable {
//    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
//        @objc
//        func gestureRecognizer(
//            _ gestureRecognizer: UIGestureRecognizer,
//            shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
//        ) -> Bool {
//            true
//        }
//    }
//
//    @Binding var location: CGPoint?
//
//    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
//        Coordinator()
//    }
//
//    func makeUIGestureRecognizer(context: Context) -> UILongPressGestureRecognizer {
//        let recognizer = UILongPressGestureRecognizer()
//        recognizer.minimumPressDuration = 0
//        recognizer.delegate = context.coordinator
//
//        return recognizer
//    }
//
//    func handleUIGestureRecognizerAction(
//        _ recognizer: UIGestureRecognizerType, context: Context) {
//            switch recognizer.state {
//            case .began:
//                location = context.converter.localLocation
//            case .ended, .cancelled, .failed:
//                location = nil
//            default:
//                break
//            }
//        }
//}
//
//extension View {
//    func makeRippleEffect<T: Equatable>(at: CGPoint, trigger: T) -> some View {
//        self.modifier(RippleEffect(at: at, trigger: trigger))
//    }
//}
