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
struct dataBox: View {
    var data: [[Double]]
    var dates: [[Date]]
    @Binding var indexPosition: Int
    var statNames: [String]
    var width: Double
    var gradients: [Gradient]
    var body: some View {
        VStack{
            Text(getTimeComponent(date: dates[0][indexPosition], timeFrame: getTimeRangeVal(dates: dates[0])))
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray))
            Divider()
            HStack{
                ForEach(statNames.indices, id: \.self){indice in
                    VStack{
                        HStack{
                            Circle()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundStyle(LinearGradient(gradient: gradients[indice], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 0.0)))
                            Text(String(data[indice][indexPosition]))
                        }
                        Text(statNames[indice])
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                    .frame(width: width/Double(statNames.count), height: 50, alignment: .center)
                }
            }
        }
        .frame(width: width, height: 75, alignment: .center)
    }
}
struct MultiLineGraph: View {
    @Binding var data: [[Double]]
    @Binding var dataWithLabels: [[Date]]?
    var height: Double?
    var width: Double?
    var gradients: [Gradient]?
    var backgroundColor: Color?
    var statNames: [String]?
    var title: String?
    @State private var showingIndicators: Bool = false
    @State private var indexPosition: Int = 0
    @State private var IndicatorPointPosition: CGPoint = .zero
    var body: some View {
        if data[0].count != 1 {
            VStack{
                if showingIndicators && dataWithLabels != nil{
                    dataBox(data: data, dates: dataWithLabels!, indexPosition: $indexPosition, statNames: statNames!, width: width!, gradients: gradients!)
                } else if dataWithLabels != nil {
                    HStack{
                        Text(title ?? "Todays Readings")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .padding(.horizontal)
                            .padding(.leading, 25)
                        Spacer()
                        VStack{
                            Text(String(format: "%.1f", averageData(data: data[0])) + " / " + String(format: "%.1f", averageData(data: data[1])))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [Color.blue, Color.purple], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                                .animation(.none)
                                .frame(height: 30, alignment: .center)
                            Divider()
                            Text("Average")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray))
                                .frame(height: 10)
                        }
                        .frame(width: 170)
                    }
                }
                ZStack{
                    if dataWithLabels != nil {
                        graphLines(width: width!, height: height!, data: addLists())
                    }
                    ForEach(data, id: \.self) { numbers in
                        let strokeColor = gradients![data.firstIndex(where: {$0 == numbers})!]
                        let yPositions = genYvalues(data: numbers, ySize: height!, dataRange: getDataRange(data: data), dataMin: getMinimumValue(data: data))
                        let xPositions = genXvalues(data: numbers, xSize: width!)
                        ZStack{
                            ForEach(numbers.indices, id: \.self) {i in
                                Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                                    .stroke(LinearGradient(
                                        gradient: strokeColor,
                                        startPoint: UnitPoint(x: 1.0, y: 0.0),
                                    endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                            }
                        }
                    }
                    if showingIndicators && dataWithLabels != nil {
                        GeometryReader { geo in
                            VStack{
                                
                            }
                            .frame(width: width!/8, height: height!, alignment: .center)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                            .position(x: IndicatorPointPosition.x > width!/16 ? IndicatorPointPosition.x : width!/16, y: geo.frame(in: .local).minY + height!/2)
                        }
                    }
                }
                .frame(width: CGFloat(width!), height: CGFloat(height!))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                        .onChanged({ value in  // Get value of the gesture
                            switch value {
                            case .second(true, let drag):
                                if let longPressLocation = drag?.location {
                                    dragGesture(longPressLocation)
                                }
                            default:
                                break
                            }
                        })
                        // Hide indicator when finish
                        .onEnded({ value in
                            self.showingIndicators = false
                        })
                    )
            }
        } else {
            Text("No Data")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.systemGray))
                .frame(width: CGFloat(width!), height: CGFloat(height!))
        }
    }
    public func dragGesture(_ longPressLocation: CGPoint) {
            let (closestXPoint, closestYPoint, yPointIndex) = getClosestValueFrom(longPressLocation)
            withAnimation(){
                self.IndicatorPointPosition.x = closestXPoint
                IndicatorPointPosition.y = closestYPoint
                showingIndicators = true
                indexPosition = yPointIndex
            }
        }
    public func getClosestValueFrom(_ value: CGPoint) -> (CGFloat, CGFloat, Int){
            let touchPoint: (CGFloat, CGFloat) = (value.x, value.y)
            let xPositions = genXvalues(data: data[0], xSize: width!)
            let yPositions = genYvalues(data: data[0], ySize: height!, dataRange: nil, dataMin: nil)
            // Closest X value
            let closestXPoint = xPositions.enumerated().min( by: { abs($0.1 - touchPoint.0) < abs($1.1 - touchPoint.0) } )!
            let closestYPointIndex = xPositions.firstIndex(of: closestXPoint.element)!
            let closestYPoint = yPositions[closestYPointIndex]
            
            // Index of the closest points in the array
            let yPointIndex = closestYPointIndex
            

            return (closestXPoint.element, closestYPoint, yPointIndex)
        }
    func addLists() -> [Double] {
        var addedList : [Double] = []
        for values in data {
            addedList = addedList + values
        }
        return addedList
    }
}
