//
//  GraphView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI

struct Line: Shape {
    var start, end: CGPoint

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}
extension Line {
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(start.animatableData, end.animatableData) }
        set { (start.animatableData, end.animatableData) = (newValue.first, newValue.second) }
    }
}
func genXvalues(data: [Double], xSize: Double) -> [Double] {
    let dataLength = data.count
    var xPositions: [Double] = [Double]()
    for i in 0..<dataLength {
        let newElement: Double = Double(i) * (xSize/Double(dataLength - 1))
        xPositions.append(newElement)
    }
    return xPositions
}
func genYvalues(data: [Double], ySize: Double, dataRange: Double?, dataMin: Double?) -> [Double] {
    var usedRange: Double
    var subtractVal: Double
    let UsedYSize = ySize - 20
    let dataLength = data.count
    if dataRange == nil {
        usedRange = data.max()! - data.min()!
    } else {
        usedRange = dataRange!
    }
    if dataMin == nil {
        subtractVal = data.min()!
    } else {
        subtractVal = dataMin!
    }
    var yPositions: [Double] = [Double]()
    for i in 0..<dataLength {
        let newElement = UsedYSize * ((data[i] - subtractVal)/usedRange) //+ 10
        yPositions.append(newElement)
    }
    return yPositions
}
func getLeadingVal(Positions: [Double], i: Int) ->  Double {
    if i == Positions.count - 1 {
        return Positions[i]
    } else {
        return Positions[i + 1]
    }
}
func getUnloadedYpositions(yPositions: [Double]) -> [Double]{
    var fakeYpositions: [Double] = []
    for i in yPositions{
        fakeYpositions.append(10)
    }
    return fakeYpositions
}
public struct IndicatorPoint: View {
    @Binding var index: Int
    var data: [Double]
    public var body: some View {
        ZStack {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.white)
                .shadow(color: Color.white, radius: 1, x: 0.0, y: 0.0)
                .opacity(0.1)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.blue)
        }
        .padding(.top, 40)
    }
}
struct graphReading: View {
    @Binding var indexPosition: Int
    @Binding var showingIndicators: Bool
    var width: Double
    var dates: [Date]
    var doubles: [Double]
    var title: String
    var body: some View {
        ZStack{
            HStack{
                if showingIndicators {
                    Spacer()
                    Text(getTimeComponent(date: dates[indexPosition], timeFrame: getTimeRangeVal(dates: dates)))
                        .foregroundColor(Color(UIColor.systemGray))
                        .padding(.leading, 70)
                    Spacer()
                } else {
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                }
                VStack {
                    Text(String(Int(showingIndicators ? doubles[indexPosition] : averageData(data: doubles))))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(colors: [Color.blue, Color.purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 0.0)))
                        .frame(width: 70, height: 30)
                        .animation(.none)
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
        .frame(width: width, height: 30, alignment: .center)
    }
}
struct graphLines: View {
    var width: Double
    var height: Double
    var data: [Double]
    var forCapsule: Bool = false
    var body: some View {
        let numHorizontalLines: Int = Int(width/25.0)
        let numVerticalLines: Int = Int(height/25.0)
        let range: Double = getRange(data: data)
        let min: Double = getMin(data: data)
        ZStack{
            ForEach(0..<numHorizontalLines, id: \.self){i in
                Line(start: CGPoint(x: 0, y: Double(i) * height/Double(numHorizontalLines)), end: CGPoint(x: width, y: Double(i) * height/Double(numHorizontalLines)))
                    .stroke(Color(UIColor.systemGray).opacity(i == 0 ? 1.0: 0.4), lineWidth: 0.5)
                    .allowsHitTesting(false)
                if i != 0{
                    Text(getXlabel(min: min, range: range, i: Double(i), numHorizontalLines: Double(numHorizontalLines), forCapsule: forCapsule))
                        .font(.footnote)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color(UIColor.systemGray))
                        .scaleEffect(CGSize(width: 1.0, height: -1.0))
                        .position(x: -15, y: Double(i) * height/Double(numHorizontalLines))
                }
            }
            ForEach(0..<numVerticalLines, id: \.self){i in
                Line(start: CGPoint(x: Double(i) * width/Double(numVerticalLines), y: 0), end: CGPoint(x: Double(i) * width/Double(numVerticalLines), y: height))
                    .stroke(Color(UIColor.systemGray).opacity(i == 0 ? 1.0: 0.4), lineWidth: 0.5)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: CGFloat(width), height: CGFloat(height))
    }
    func getXlabel(min: Double, range: Double, i: Double, numHorizontalLines: Double, forCapsule: Bool) -> String{
        if !forCapsule{
            return String(Int(min + Double(i) * (range/numHorizontalLines + 1)))
        } else {
            return String(Int(min + Double(i + 1) * (range/numHorizontalLines)))
        }
    }
}
struct LineGraph: View {
    @Binding var data: [Double]
    @Binding var dataTime: [Date]? ///Maybe change this to a binding but its a fucking headache for now
    @State var height: Double?
    @State var width: Double?
    @State var color: Color?
    @State var gradient: Gradient?
    @State var backgroundColor: Color?
    var title: String? = "Todays Readings"
    @State private var showingIndicators: Bool = false
    @State private var indexPosition: Int = 0
    @State private var IndicatorPointPosition: CGPoint = .zero
    @State private var loaded = false
    var body: some View {
        let yPositions = genYvalues(data: data, ySize: height!, dataRange: nil, dataMin: nil)
        let fakeYPositions = getUnloadedYpositions(yPositions: yPositions)
        let xPositions = genXvalues(data: data, xSize: width!)
        if dataTime?.count != 1 {
            VStack {
                if dataTime != nil {
                    graphReading(indexPosition: $indexPosition
                                 , showingIndicators: $showingIndicators, width: width!, dates: dataTime!, doubles: data, title: title!)
                }
                ZStack {
                    ZStack {
                        graphLines(width: width!, height: height!, data: data)
                        if data[0] != 0 {
                            ForEach(data.indices, id: \.self) {i in
                                if gradient == nil {
                                    Line(start: CGPoint(x: xPositions[i], y: loaded ? yPositions[i] : fakeYPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: loaded ? yPositions : fakeYPositions, i: i)))
                                        .stroke(color!, lineWidth: 2)
                                } else {
                                    Line(start: CGPoint(x: xPositions[i], y: loaded ? yPositions[i] : fakeYPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: loaded ? yPositions : fakeYPositions, i: i)))
                                        .stroke(LinearGradient(
                                            gradient: gradient!,
                                            startPoint: UnitPoint(x: 0.0, y: 1.0),
                                        endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                                }
                                
                                if showingIndicators {
                                    withAnimation(){
                                        IndicatorPoint(index: $indexPosition, data: data)
                                                        .position(x: IndicatorPointPosition.x, y: IndicatorPointPosition.y - 20)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: CGFloat(width!), height: CGFloat(height!))
                    .padding([.leading, .trailing, .bottom], 15)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
                }
                .onAppear(){
                    withAnimation(Animation.easeInOut(duration: 2.0)){
                        loaded = true
                    }
                }
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                
                 // Control tappable area
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
            let xPositions = genXvalues(data: data, xSize: width!)
            let yPositions = genYvalues(data: data, ySize: height!, dataRange: nil, dataMin: nil)
            // Closest X value
            let closestXPoint = xPositions.enumerated().min( by: { abs($0.1 - touchPoint.0) < abs($1.1 - touchPoint.0) } )!
            let closestYPointIndex = xPositions.firstIndex(of: closestXPoint.element)!
            let closestYPoint = yPositions[closestYPointIndex]
            
            // Index of the closest points in the array
            let yPointIndex = closestYPointIndex
            

            return (closestXPoint.element, closestYPoint, yPointIndex)
        }
}
