//
//  GraphInferenceTrendGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/8/22.
//

import SwiftUI

struct GraphInferenceTrendGraphView: View {
    var slope: Double
    var yIntercept: Double
    var data: [Double]
    var dataRange: Double?
    var dataMin: Double?
    var height: Double
    var width: Double
    var body: some View {
        ZStack{
            let yValues = getYvals()
            Line(start: CGPoint(x: (1/2 * width), y: yValues[0]), end: CGPoint(x: 2 * width  - (1/2 * width), y: yValues[1]))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.pink)
                .frame(height: 1)
            VStack{
                Text(String(abs(Int(100 * (((slope * Double(data.count)) + yIntercept) - data[0])/((slope * Double(data.count)) + yIntercept)))) + "%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(colors: [.pink, .orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                Text(slope < 0 ? "Lower": "Higher")
            }
            //.scaleEffect(CGSize(width: 1.0, height: -1.0))
            .position(x: 1.5 * width  - (1/2 * width), y: height)
            .zIndex(2)
        }
        .frame(width: width, height: height, alignment: .center)
    }
    func getYvals() -> [Double] {
        let startEnd = [yIntercept, (slope * Double(data.count)) + yIntercept]
        return genYvalues(data: startEnd, ySize: height, dataRange: dataRange, dataMin: dataMin)
    }
}
func getTrendPercent(dataFirst: Double, dataLen: Int, slope: Double, yIntercept: Double) -> Int{
    return Int(100 * (((slope * Double(dataLen)) + yIntercept) - dataFirst)/((slope * Double(dataLen)) + yIntercept))
}
