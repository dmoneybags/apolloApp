//
//  GraphInferenceAverageGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/8/22.
//

import SwiftUI

struct GraphInferenceAverageGraphView: View {
    var value: Double
    var allTimeAverage:Double
    var dataRange: Double?
    var dataMin: Double?
    var width: Double
    var height: Double
    private let stopWatch = StopWatchManager(timeLim: 2.0)
    @State private var viewOpacity: Double = 1.0
    var body: some View {
        ZStack{
            Line(start: CGPoint(x: width - (1/2 * width), y: getAverageYposition()), end: CGPoint(x: 2 * width  - (1/2 * width), y: getAverageYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.blue)
                .frame(height: 1)
            Text("Current Average")
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .position(x: width, y: height/2 + getAverageYposition() + 20)
            Line(start: CGPoint(x: width - (1/2 * width), y: getAllTimeAverageYposition()), end: CGPoint(x: 2 * width  - (1/2 * width), y: getAllTimeAverageYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.purple)
                .frame(height: 1)
            Text("All Time Average")
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .position(x: width, y: height/2 + getAllTimeAverageYposition() + 20)
        }
    }
    func getAverageYposition() -> Double{
        return genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
    func getAllTimeAverageYposition() -> Double{
        print(allTimeAverage)
        return genYvalues(data: [allTimeAverage], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
}
