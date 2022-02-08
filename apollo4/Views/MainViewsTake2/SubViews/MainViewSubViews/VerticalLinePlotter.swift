//
//  VerticalLinePlotter.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/16/21.
//

import SwiftUI

struct VerticalLinePlotter: View {
    @Binding var data: [(Double, Date)]
    var title: String
    var stat : Stat
    var width : Double
    var height : Double
    private var min : Double {
        return stat.getRange(label: "").0
    }
    private var max : Double {
        return stat.getRange(label: "").1
    }
    private var range : Double {
        return (stat.getRange(label: "").1 -  stat.getRange(label: "").0)
    }
    private var dataVal : Double {
        if showingIndicators {
            return data.map{$0.0}[indexPosition]
        } else {
            return averageData(data: data.map{$0.0})
        }
    }
    private var dateVal : Date? {
        if showingIndicators {
            return data.map{$0.1}[indexPosition]
        } else {
            return nil
        }
    }
    @State private var showingIndicators: Bool = false
    @State private var indexPosition: Int = 0
    @State private var IndicatorPointPosition: CGPoint = .zero
    @State private var loaded = false
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color(UIColor.systemGray))
                        .padding(.horizontal)
                    Spacer()
                    VStack{
                        Text(String(format: "%.1f", dataVal))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(LinearGradient(colors: [Color.blue, Color.purple], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                            .animation(.none)
                            .frame(width: 80, height: 30, alignment: .center)
                        if !showingIndicators{
                            Divider()
                            Text("Average")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray))
                                .frame(height: 10)
                        }
                    }
                    .frame(width: 80)
                }
            }
            .frame(width: width, height: height/4, alignment: .center)
            if data.map{$0.0}.count > 1 {
                HStack{
                    ForEach(data.indices, id: \.self){indice in
                        let value = data[indice]
                        let capsuleHeight = height/2 * abs(value.0 - min)/range + 2
                        let paddingTop = (height/2 - (1 * capsuleHeight)) - 10
                        Capsule()
                            .frame(width: 1, height: capsuleHeight)
                            .foregroundStyle(LinearGradient(colors: [Color.pink, Color.purple], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                            .padding(.top, paddingTop)
                            .scaleEffect((indice == indexPosition && showingIndicators) ? 1.2 : 1.0)
                        Spacer()
                    }
                }
                .frame(width: width, height: height/2, alignment: .center)
                .gesture(
                    LongPressGesture(minimumDuration: 0.01)
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
                VStack{
                    HStack {
                        if dateVal != nil {
                            Text(getTimeComponent(date: dateVal!, timeFrame: getTimeRangeVal(dates: data.map{$0.1})))
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                HorizontalCapsuleReader(progress: (dataVal - min)/range, width: width - 20, height: 15, gradient: Gradient(colors: [Color.pink, Color.purple, Color.blue]))
                }
                .frame(width: width, height: height/4, alignment: .center)
            } else {
                Text("No Data")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: width, height: 1.5 * height/2)
            }
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
            let xPositions = genXvalues(data: data.map{$0.0}, xSize: width)
            let yPositions = genYvalues(data: data.map{$0.0}, ySize: height, dataRange: nil, dataMin: nil)
            // Closest X value
            let closestXPoint = xPositions.enumerated().min( by: { abs($0.1 - touchPoint.0) < abs($1.1 - touchPoint.0) } )!
            let closestYPointIndex = xPositions.firstIndex(of: closestXPoint.element)!
            let closestYPoint = yPositions[closestYPointIndex]
            
            // Index of the closest points in the array
            let yPointIndex = closestYPointIndex
            

            return (closestXPoint.element, closestYPoint, yPointIndex)
        }
}

