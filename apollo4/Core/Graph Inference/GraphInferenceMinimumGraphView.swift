//
//  graphInferenceMinimumGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/6/22.
//

import SwiftUI

struct GraphInferenceMinMaxGraphView: View {
    var value: Double
    var index: Int
    var dataRange: Double?
    var dataMin: Double?
    var graphData: [Double]
    var width: Double
    var height: Double
    var color: Color
    var gradient: Gradient
    var isMin: Bool = true
    private let stopWatch = StopWatchManager(timeLim: 2.0)
    @State private var viewOpacity: Double = 1.0
    var body: some View {
        ZStack{
            VStack{
                Text(isMin ? String(100 - Int(100 * value/averageData(data: graphData))) + "%": String(Int(100 * value/averageData(data: graphData)) - 100) + "%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                Text(isMin ? "Lower": "Higher")
            }
            //.scaleEffect(CGSize(width: 1.0, height: -1.0))
            .position(x: 1.5 * width  - (1/2 * width), y: height)
            .zIndex(2)
            Line(start: CGPoint(x: width - (1/2 * width), y: getMinimumYposition()), end: CGPoint(x: 2 * width  - (1/2 * width), y: getMinimumYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(color)
                .frame(height: 1)
        }
        .onChange(of: stopWatch.mode){mode in
            if mode == .stopped{
                withAnimation(){
                    viewOpacity = 0.0
                }
            }
        }
        .frame(width: width, height: height)
        .opacity(viewOpacity)
    }
    func getMinimumYposition() -> Double{
        print(genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0])
        return genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
}
