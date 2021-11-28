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
        let newElement: Double = Double(i) * (xSize/Double(dataLength))
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
public struct IndicatorPoint: View {
    @Binding var index: Int
    var data: [Double]
    public var body: some View {
        VStack {
            VStack{
                Text(String(Int(data[index])))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .scaleEffect(CGSize(width: 1.0, height: -1.0))
                    .font(.callout)
            }
            .frame(width: 30, height: 30, alignment: .center)
            .background(Color.white)
            .cornerRadius(5)
            Circle()
                .frame(width: 20, height: 20)
            .foregroundColor(Color.blue)
        }
    }
}
struct LineGraph: View {
    @Binding var data: [Double]
    @State var dataTime: [(Double, Date)]? ///Maybe change this to a binding but its a fucking headache for now
    @State var height: Double?
    @State var width: Double?
    @State var color: Color?
    @State var gradient: Gradient?
    @State var backgroundColor: Color?
    @State var heatGradient: Bool = false
    @State var showingIndicators: Bool = false
    @State var indexPosition: Int = 0
    @State var IndicatorPointPosition: CGPoint = .zero
    var body: some View {
        let yPositions = genYvalues(data: dataTime != nil ? dataTime!.map{$0.0}:data, ySize: height!, dataRange: nil, dataMin: nil)
        let xPositions = genXvalues(data: dataTime != nil ? dataTime!.map{$0.0}:data, xSize: width!)
        ZStack {
            ZStack {
                ForEach(data.indices, id: \.self) {i in
                    if heatGradient {
                        Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                            .stroke(LinearGradient(
                                gradient: tempGradient,
                                startPoint: UnitPoint(x: 0.0, y: 1.0),
                            endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                    } else {
                        if gradient == nil {
                            Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                                .stroke(color!, lineWidth: 2)
                        } else {
                            Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                                .stroke(LinearGradient(
                                    gradient: gradient!,
                                    startPoint: UnitPoint(x: 0.0, y: 1.0),
                                endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                        }
                    }
                    if showingIndicators {
                        withAnimation(){
                            IndicatorPoint(index: $indexPosition, data: dataTime != nil ? dataTime!.map{$0.0} : data)
                                            .position(x: IndicatorPointPosition.x, y: IndicatorPointPosition.y - 15)
                        }
                    }
                }
                .frame(width: CGFloat(width!), height: CGFloat(height!))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
                
            }
        }
        .scaleEffect(CGSize(width: 1.0, height: -1.0))
        .contentShape(Rectangle())  // Control tappable area
                .gesture(
                    LongPressGesture(minimumDuration: 0.2)
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
        public func dragGesture(_ longPressLocation: CGPoint) {
                let (closestXPoint, closestYPoint, yPointIndex) = getClosestValueFrom(longPressLocation)
                self.IndicatorPointPosition.x = closestXPoint
                IndicatorPointPosition.y = closestYPoint
                showingIndicators = true
                indexPosition = yPointIndex
            }
        public func getClosestValueFrom(_ value: CGPoint) -> (CGFloat, CGFloat, Int){
                let touchPoint: (CGFloat, CGFloat) = (value.x, value.y)
                let xPositions = genXvalues(data: data, xSize: width!)
                let yPositions = genYvalues(data: data, ySize: height!, dataRange: nil, dataMin: nil)
                // Closest X value
                let closestXPoint = xPositions.enumerated().min( by: { abs($0.1 - touchPoint.0) < abs($1.1 - touchPoint.0) } )!
                let closestYPointIndex = xPositions.firstIndex(of: closestXPoint.element)!
                let closestYPoint = yPositions[closestYPointIndex]
                
                print(closestYPoint)
                // Index of the closest points in the array
                let yPointIndex = yPositions.firstIndex(of: closestYPoint)!
                

                return (closestXPoint.element, closestYPoint, yPointIndex)
            }
    }
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
    print("Setting Range as \(max - min)")
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
struct MultiLineGraph: View {
    @Binding var data: [[Double]]
    @State var height: Double?
    @State var width: Double?
    @State var gradients: [Gradient]?
    @State var backgroundColor: Color?
    var body: some View {
        ZStack{
            ForEach(data, id: \.self) { numbers in
                let strokeColor = gradients![data.firstIndex(where: {$0 == numbers})!]
                let yPositions = genYvalues(data: numbers, ySize: height!, dataRange: getDataRange(data: data), dataMin: getMinimumValue(data: data))
                let xPositions = genXvalues(data: numbers, xSize: width!)
                ZStack{
                    ForEach(numbers.indices, id: \.self) {i in
                        Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                            .stroke(LinearGradient(
                                gradient: strokeColor,
                                startPoint: UnitPoint(x: 0.0, y: 1.0),
                            endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                    }
                }
            }
        }
        .frame(width: CGFloat(width!), height: CGFloat(height!))
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
        .scaleEffect(CGSize(width: 1.0, height: -1.0))
    }
}
