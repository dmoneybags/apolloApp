//
//  MultilineMinimumGraphview.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/10/22.
//

import SwiftUI

struct MultilineMinMaxGraphview: View {
    var width: Double
    var height: Double
    var graphData: [[Double]]
    var aggregateMin: [Double]
    var minIndex: Int
    var gradients: [Gradient]
    @State private var boxInFocus = -1
    private var minXPosition: Double {
        return genXvalues(data: graphData[0], xSize: width)[minIndex]
    }
    private var minYPositions: [Double] {
        var yPos: [Double] = []
        for listVal in graphData {
            let yPositions = genYvalues(data: listVal, ySize: height, dataRange: getDataRange(data: graphData), dataMin: getMinimumValue(data: graphData))
            //Add 1/2 height due to swift positioning nonsense
            yPos.append(height/2 + yPositions[minIndex])
        }
        print("Positioning circles at \(yPos)")
        return yPos
    }
    var body: some View {
        ZStack{
            Line(start: CGPoint(x: -(width/2 - minXPosition), y: 0), end: CGPoint(x: -(width/2 - minXPosition), y: height))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.purple)
                .frame(height: 1)
            ForEach(minYPositions.indices, id: \.self){indice in
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(LinearGradient(gradient: gradients[indice], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                    .position(x: -(width/2 - minXPosition), y: minYPositions[indice])
                    .onTapGesture{
                        boxInFocus = indice
                    }
                if boxInFocus == indice {
                    let percent = (graphData[indice][minIndex] - averageData(data: graphData[indice]))/averageData(data: graphData[indice])
                    InferenceInfoBox(doubleVal: graphData[indice][minIndex], percent: abs(percent), isHigher: percent > 0, gradient: gradients[indice])
                        .position(x: minXPosition > width/2 ? -(width/2 - minXPosition) - 80 : -(width/2 - minXPosition) + 80, y: getBoxPosition(yPosition: minYPositions[indice]))
                        .onAppear{
                            print(minYPositions[indice])
                            print(height)
                        }
                }
            }
        }
        .frame(width: width, height: height)
    }
    private func getBoxPosition(yPosition: Double) -> Double{
        if yPosition < height/2 + 60{
            return height/2 + 60
        }
        if yPosition > 3/2 * height - 60{
            return 3/2 * height - 60
        }
        return yPosition
    }
}
