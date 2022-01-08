//
//  graphInferenceMinimumGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/6/22.
//

import SwiftUI

struct GraphInferenceMinMaxGraphView: View {
    var minimum: Double
    var minIndex: Int
    var dataRange: Double
    var dataMin: Double
    var graphData: [Double]
    var width: Double
    var height: Double
    var color: Color
    var gradient: Gradient
    private let stopWatch = StopWatchManager(timeLim: 2.0)
    @State private var viewOpacity: Double = 1.0
    var body: some View {
        ZStack{
            VStack{
                Text(String(100 - Int(100 * minimum/averageData(data: graphData))) + "%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                Text("Lower")
            }
            .scaleEffect(CGSize(width: 1.0, height: -1.0))
            .position(x: 1.5 * width  - (1/2 * width), y: height)
            .zIndex(2)
            Line(start: CGPoint(x: width - (1/2 * width), y: getMinimumYposition()), end: CGPoint(x: 2 * width  - (1/2 * width), y: getMinimumYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(Color.purple)
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
        return genYvalues(data: [minimum], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
}
