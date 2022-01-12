//
//  MultilineAverageGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/11/22.
//

import SwiftUI

struct MultilineAverageGraphView: View {
    var width: Double
    var height: Double
    var dataRange: Double
    var dataMin: Double
    var averages: [Double]
    var aggregateAverages: [Double]
    var gradients: [Gradient]
    var statNames: [String]
    @State private var showLegend: Bool = true
    var body: some View {
        let averageList = averages + aggregateAverages
        ZStack{
            ForEach(averageList.indices, id:\.self){i in
                Line(start: CGPoint(x: -width/2, y: getAverageYposition(value: averageList[i])), end: CGPoint(x: width/2, y: getAverageYposition(value: averageList[i])))
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(LinearGradient(gradient: gradients[i], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 0.0)))
                    .frame(height: 1)
            }
            if showLegend{
                InferenceMultiLineAverageBox(gradients: gradients, names: statNames)
                    .position(x: width/2 - 80, y: height)
                    .scaleEffect(0.7)
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged(){_ in
                    showLegend = false
                }
                .onEnded(){_ in
                    showLegend = true
                }
        )
        .frame(width: width, height: height)
    }
    func getAverageYposition(value: Double) -> Double{
        return genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
}
