//
//  MultiLineGraph.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/27/21.
//

import SwiftUI

private func getDataRange(data: [[Double]]) -> Double {
    var min = Double(100000000000)
    var max = Double(0)
    for numbers in data {
        if numbers.min()! < min {
            min = numbers.min()!
        }
        if numbers.max()! > max {
            max = numbers.max()!
        }
    }
    print("Setting Range as \(max - min)")
    return max - min
}
private func getMinimumValue(data: [[Double]]) -> Double {
    var min = Double(100000000000)
    for numbers in data {
        if numbers.min()! < min {
            min = numbers.min()!
        }
    }
    return min
}
struct MultiLineGraph: View {
    @Binding var data: [[Double]]
    @State var height: Double?
    @State var width: Double?
    @State var gradients: [Gradient]?
    @State var backgroundColor: Color?
    var body: some View {
        ZStack{
            ForEach(data, id: \.self) { numbers in
                let strokeColor = gradients![data.firstIndex(where: {$0 == numbers})!]
                let yPositions = genYvalues(data: numbers, ySize: height!, dataRange: getDataRange(data: data), dataMin: getMinimumValue(data: data))
                let xPositions = genXvalues(data: numbers, xSize: width!)
                ZStack{
                    ForEach(numbers.indices, id: \.self) {i in
                        Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                            .stroke(LinearGradient(
                                gradient: strokeColor,
                                startPoint: UnitPoint(x: 0.0, y: 1.0),
                            endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                    }
                }
            }
        }
        .frame(width: CGFloat(width!), height: CGFloat(height!))
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
        .scaleEffect(CGSize(width: 1.0, height: -1.0))
    }
}
