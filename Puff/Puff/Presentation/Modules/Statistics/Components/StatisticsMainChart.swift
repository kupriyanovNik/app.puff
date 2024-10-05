//
//  StatisticsMainChart.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

struct StatisticsMainChart: View {

    var keys: [String]
    @Binding var realValues: [Int?]
    @Binding var estimatedValues: [Int?]

    @Binding var selectedIndex: Int?

    var spacingBetweenChartCells: CGFloat = 6
    var chartCellHeight: CGFloat = 100

    @State private var chartWidth: CGFloat = .zero

    private var biggestValue: Int {
        let realValues = realValues.compactMap { $0 }
        let estimatedValues = estimatedValues.compactMap { $0 }

        if realValues.isEmpty && estimatedValues.isEmpty {
            return 0
        }

        var maxReal = Int.min
        for i in realValues {
            maxReal = max(maxReal, i)
        }

        var maxEst = Int.min
        for i in estimatedValues {
            maxEst = max(maxEst, i)
        }

        return max(maxEst, maxReal)
    }

    private var gesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                handleDragGesture(
                    startLocation: value.startLocation,
                    translation: value.translation
                )

            }
            .onEnded { value in
                selectedIndex = nil
            }
    }

    private func handleDragGesture(startLocation: CGPoint, translation: CGSize) {
        let widthPointX = startLocation.x + translation.width
        let part: Double = widthPointX / chartWidth
        let maxCount = max(realValues.count, estimatedValues.count)

        selectedIndex = max(0, min(Int(Double(part) * Double(maxCount)), maxCount - 1))
    }

    var body: some View {
        HStack(spacing: 4) {
            VStack(spacing: 8) {
                chartView()
                    .height(chartCellHeight)
                    .getWidth(width: $chartWidth)
                    .background {
                        VStack {
                            Line()
                                .stroke(Color(hex: 0xEFEFEF), style: .init(dash: [5]))
                                .height(1)

                            Spacer()

                            Line()
                                .stroke(Color(hex: 0xEFEFEF), style: .init(dash: [5]))
                                .height(1)

                            Spacer()

                            Line()
                                .stroke(Color(hex: 0xEFEFEF), style: .init(lineWidth: 1))
                                .height(1)
                        }
                        .padding(.trailing, 3)
                        .padding(.top, 8)
                    }
                    .gesture(self.gesture)

                xMarks()
            }

            yMarks()
        }

    }

    @ViewBuilder
    private func chartView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size

            HStack(spacing: spacingBetweenChartCells) {
                ForEach(realValues.indices) { index in
                    let realValue: Int? = realValues[min(index, realValues.count - 1)]
                    let estimatedValue: Int? = estimatedValues[min(index, estimatedValues.count - 1)]

                    let isSelected = selectedIndex == index

                    Color.clear
                        .overlay {
                            Group {
                                if realValue == nil, estimatedValue == nil {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: isSelected ? 0xDDDDDD : 0xEFEFEF))
                                        .height(6)
                                        .vBottom()
                                } else if let realValue, estimatedValue == nil {
                                    let heightOfReal = (max(0, Double(realValue - 6)) / Double(max(1, biggestValue))) * size.height + 6

                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: isSelected ? 0x75B8FD : 0xB5D9FF))
                                        .height(heightOfReal)
                                        .vBottom()
                                } else if realValue == nil, let estimatedValue {
                                    let heightOfEstimated = (max(0, Double(estimatedValue - 6)) / Double(max(1, biggestValue))) * size.height + 6

                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: isSelected ? 0xDDDDDD : 0xEFEFEF))
                                        .height(heightOfEstimated)
                                        .vBottom()
                                } else if let realValue, let estimatedValue {
                                    let heightOfEstimated = (max(0, Double(estimatedValue - 6)) / Double(max(1, biggestValue))) * size.height + 6
                                    let heightOfReal = (max(0, Double(realValue - 6)) / Double(max(1, biggestValue))) * size.height + 6

                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: isSelected ? 0xDDDDDD : 0xEFEFEF))
                                        .overlay(alignment: .bottom) {
                                            if heightOfReal <= heightOfEstimated {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: isSelected ? 0x75B8FD : 0xB5D9FF))
                                                    .height(heightOfReal)
                                            } else {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: isSelected ? 0xFF7D7D : 0xFDB9BA))
                                                    .height(heightOfReal)
                                            }
                                        }
                                        .height(heightOfEstimated)
                                        .vBottom()
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.25), value: isSelected)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    @ViewBuilder
    private func xMarks() -> some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(.medium11)
                    .foregroundStyle(Palette.textQuaternary)
                    .padding(.vertical, 2)
                    .hCenter()
            }
        }
    }

    @ViewBuilder
    private func yMarks() -> some View {
        VStack {
            Text("\(biggestValue == 0 ? 500 : biggestValue)")

            Spacer()

            Text("\(biggestValue == 0 ? 250 : Int(biggestValue / 2))")
                .offset(y: 3)

            Spacer()

            Text("0")
        }
        .font(.medium11)
        .foregroundStyle(Palette.textQuaternary)
        .padding(.bottom, 26)
    }

    struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            return path
        }
    }
}
