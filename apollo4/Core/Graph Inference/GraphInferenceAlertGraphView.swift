//
//  GraphInferenceAlertGraphView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/29/22.
//

import SwiftUI

struct GraphInferenceAlertGraphView: View {
    var value: Double
    var graphData: [(Double, Date)]
    var alerts: [(Double, Date)]
    var pooledAlerts: [(Double, Date)]
    var above: Bool
    var dataRange: Double
    var dataMin: Double
    var width: Double
    var height: Double
    @State private var rangeIndice: Int? = nil
    var body: some View {
        let (alertRanges, timeRanges) = getAlertRanges()
        ZStack{
            if rangeIndice != nil {
                GraphInferenceLegendBox(title: "Alerts", subTitle: getSubTitle(indice: rangeIndice!, timeRanges: timeRanges), numItems: 7){
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(timeRanges[rangeIndice!].1.timeIntervalSince1970 - timeRanges[rangeIndice!].0.timeIntervalSince1970))
                    Text("\(h) Hours")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(colors: [.red, .orange], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Text("\(m) Minutes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(colors: [.red, .orange], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Text("\(s) Seconds")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(colors: [.red, .orange], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))

                }
            }
            Line(start: CGPoint(x: 1/2 * width, y: getValueYposition()), end: CGPoint(x: 1.5 * width, y: getValueYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.red)
            ForEach(alertRanges.indices, id: \.self){indice in
                let alertRange = alertRanges[indice]
                Group{
                    ZStack{
                        Circle()
                            .frame(width: 20, height: 20, alignment: .center)
                        Circle()
                            .frame(width: 18, height: 18, alignment: .center)
                            .foregroundColor(.red)
                        LinearGradient(colors: above ? [.red.opacity(0.3), .clear] : [.clear, .red.opacity(0.3)], startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 0, y: 0))
                            .frame(width: alertRange.1 - alertRange.0, height: above ? height : 3 * height/2 - getValueYposition())
                            .offset(x: (alertRange.1 - alertRange.0)/2, y: above ? -height/2 : (3 * height/2 - getValueYposition())/2)
                            .zIndex(-1)
                    }
                    .position(x: alertRange.0, y: getValueYposition())
                    ZStack{
                        Circle()
                            .frame(width: 20, height: 20, alignment: .center)
                        Circle()
                            .frame(width: 18, height: 18, alignment: .center)
                            .foregroundColor(.red)
                    }
                    .position(x: alertRange.1, y: getValueYposition())
                }
                .onTapGesture{
                    rangeIndice = indice
                }
            }
        }
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getValueYposition() -> Double{
        return genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0] + height/2
    }
    //returns list of (start, stop) for ranges of alerts
    func getAlertRanges() -> ([(Double, Double)], [(Date, Date)]){
        if pooledAlerts.isEmpty{
            return ([], [])
        }
        var alertIndiceRanges: [(Int, Int)] =  []
        let poolAlertIndices = getPooledAlertIndices()
        var startEnd = (-1, -1)
        for indice in graphData.indices{
            if startEnd.0 == -1{
                let start = poolAlertIndices.first(where: {indice == $0})
                if start != nil{
                    startEnd.0 = start!
                }
            } else {
                let tuple = graphData[indice]
                if above {
                    if tuple.0 < value {
                        startEnd.1 = indice
                        alertIndiceRanges.append(startEnd)
                        startEnd = (-1, -1)
                    }
                } else {
                    if tuple.0 > value {
                        startEnd.1 = indice
                        alertIndiceRanges.append(startEnd)
                        startEnd = (-1, -1)
                    }
                }
            }
        }
        if startEnd.1 == -1  && startEnd.0 != -1{
            startEnd.1 = graphData.count - 1
            alertIndiceRanges.append(startEnd)
        }
        let alertRanges = alertIndiceRanges.map({(mapToXposition(indice: $0.0), mapToXposition(indice: $0.1))})
        let timeRanges = alertIndiceRanges.map({(graphData[$0.0].1, graphData[$0.1].1)})
        print("GRAPHINFERENCEALERTGRAPHVIEW:: alertRanges, \(alertRanges)")
        return (alertRanges, timeRanges)
    }
    func getPooledAlertIndices() -> [Int]{
        var pooledAlertIndices: [Int] = []
        for tuple in pooledAlerts{
            pooledAlertIndices.append(graphData.firstIndex(where: {(tuple.0 == $0.0) && (tuple.1 == $0.1)})!)
        }
        return pooledAlertIndices
    }
    func mapToXposition(indice: Int) -> Double{
        let offset = 1/2 * width
        return (width * (Double(indice))/Double(graphData.count - 1)) + offset
    }
    func getSubTitle(indice: Int, timeRanges: [(Date, Date)]) -> String{
        let firstDate = getTimeComponent(date: timeRanges[indice].0, timeFrame: getTimeRangeVal(dates: graphData.map{$0.1}))
        let secondDate = getTimeComponent(date: timeRanges[indice].1, timeFrame: getTimeRangeVal(dates: graphData.map{$0.1}))
        return firstDate + " - " + secondDate
    }
}
