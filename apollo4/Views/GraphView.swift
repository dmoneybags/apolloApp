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
    let UsedYSize = ySize //- 20
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
        yPositions.append(ySize - newElement)
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
func getUnloadedYpositions(yPositions: [Double], height: Double) -> [Double]{
    var fakeYpositions: [Double] = []
    for _ in yPositions{
        fakeYpositions.append(height)
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
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
    var dates: [Date]? = nil
    var forCapsule: Bool = false
    var body: some View {
        let numHorizontalLines: Int = Int(width/25.0)
        let numVerticalLines: Int = Int(height/25.0)
        let range: Double = getRange(data: data)
        let min: Double = getMin(data: data)
        ZStack{
            ForEach(1..<numHorizontalLines + 1, id: \.self){i in
                Line(start: CGPoint(x: 0, y: Double(i) * height/Double(numHorizontalLines)), end: CGPoint(x: width, y: Double(i) * height/Double(numHorizontalLines)))
                    .stroke(Color(UIColor.systemGray).opacity(i == numHorizontalLines ? 1.0: 0.4), lineWidth: 0.5)
                    .allowsHitTesting(false)
                if i != numHorizontalLines{
                    Text(getXlabel(min: min, range: range, i: Double(i), numHorizontalLines: Double(numHorizontalLines), forCapsule: forCapsule))
                        .font(.footnote)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color(UIColor.systemGray))
                        //.scaleEffect(CGSize(width: 1.0, height: -1.0))
                        .position(x: -15, y: Double(i) * height/Double(numHorizontalLines))
                }
            }
            if dates == nil {
                ForEach(0..<numVerticalLines, id: \.self){i in
                    Line(start: CGPoint(x: Double(i) * width/Double(numVerticalLines), y: 0), end: CGPoint(x: Double(i) * width/Double(numVerticalLines), y: height))
                        .stroke(Color(UIColor.systemGray).opacity(i == 0 ? 1.0: 0.4), lineWidth: 0.5)
                        .allowsHitTesting(false)
                }
            } else {
                let dateLen = dates!.count - 1
                ForEach(0..<dateLen, id: \.self){i in
                    Line(start: CGPoint(x: Double(i) * width/Double(dateLen), y: 0), end: CGPoint(x: Double(i) * width/Double(dateLen), y: height))
                        .stroke(Color(UIColor.systemGray).opacity(i == 0 ? 1.0: 0.4), lineWidth: 0.5)
                        .allowsHitTesting(false)
                    if Int(i) % (Int(dates!.count/4) > 1 ? Int(dates!.count/4) : 2) == 1 {
                        Text(getTimeComponent(date: dates![i], timeFrame: getTimeRangeVal(dates: dates!)))
                            .font(.footnote)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(Color(UIColor.systemGray))
                            //.scaleEffect(CGSize(width: 1.0, height: -1.0))
                            .position(x: Double(i) * width/Double(dateLen), y: height + 15)
                    }
                }
            }
        }
        .frame(width: CGFloat(width), height: CGFloat(height))
    }
    func getXlabel(min: Double, range: Double, i: Double, numHorizontalLines: Double, forCapsule: Bool) -> String{
        if !forCapsule{
            return String(Int(min + Double(numHorizontalLines - i) * (range/numHorizontalLines)))
        } else {
            return String(Int(min + Double(i + 1) * (range/numHorizontalLines)))
        }
    }
}
struct LineGraph: View {
    //Doubles to graph
    @Binding var data: [Double]
    //Parallel list with double list of corresponding dates
    @Binding var dataTime: [Date]?
    //if not specified then highest point in data will alwats be 100% of height and lowest will be
    //0%
    var dataMin: Double? = nil
    var dataRange: Double? = nil
    //height and width of graph
    @State var height: Double?
    @State var width: Double?
    //Should the line have a color? IMPORTANT: color takes lower precedence than gradient,
    //if both are specified only gradient will be rendered
    @State var color: Color?
    //Should the line have a gradient color? (very pretty)
    @State var gradient: Gradient?
    //Should the graph have a background color? if not background color is background of lower zIndex
    //View
    @State var backgroundColor: Color?
    //Title that will show up at the top
    var title: String? = "Todays Readings"
    //Lines on the graph?
    var useLines: Bool = true
    //Is the data averaged by a timeFrame?
    var pooledData: Bool = false
    //Used for inferences, if no inferences are wanted, simply don't specify the argument
    var aggregateInference: aggregateInferenceObject? = nil
    //need a state object for object in focus for automatic updating
    @State private var objectInFocus: Int = -1
    @State private var showingIndicators: Bool = false
    @State private var indexPosition: Int = 0
    @State private var IndicatorPointPosition: CGPoint = .zero
    @State private var loaded = false
    //Messy, I know. In a perfect world I'll rewrite graphView to use a set of initializers for
    //the circumstances we'd usually see: just doubles no times, doubles and times but no inferences,
    //doubles, times, inferences, title (the whole deal). For now the logic on inferences revolves
    //around passing an optional aggregateInferenceObject. If this object is left out of the argument
    //list, absolutely NOTHING will happen related to inferences, as intended.
    private let inferenceInFocusPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "InferenceInFocus"))
    var body: some View {
        let yPositions = genYvalues(data: data, ySize: height!, dataRange: dataRange, dataMin: dataMin)
        let fakeYPositions = getUnloadedYpositions(yPositions: yPositions, height: height!)
        let xPositions = genXvalues(data: data, xSize: width!)
        if data.count > 1{
            VStack {
                if dataTime != nil {
                    graphReading(indexPosition: $indexPosition
                                 , showingIndicators: $showingIndicators, width: width!, dates: dataTime!, doubles: data, title: title!)
                }
                ZStack {
                    ZStack {
                        if useLines{
                            graphLines(width: width!, height: height!, data: dataMin == nil ? data: data + [dataMin!, dataMin! + dataRange!], dates: pooledData ? dataTime: nil)
                        }
                        if aggregateInference != nil && objectInFocus != -1 {
                            ForEach(aggregateInference!.objectsToImplement.indices, id: \.self){i in
                                if i == objectInFocus {
                                    aggregateInference!.objectsToImplement[i].getGraphView(width: width!, height: height!, graphData: data, dataRange: dataRange, dataMin: dataMin)
                                        .position(x: 0, y: 0)
                                        .zIndex(2)
                                }
                            }
                        }
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
                    .padding([.leading, .trailing, .top], 15)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
                }
                .onAppear(){
                    withAnimation(Animation.easeIn(duration: 0.7)){
                        loaded = true
                    }
                }
                //.scaleEffect(CGSize(width: 1.0, height: -1.0))
                
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
            //Who is responsible for sending this message? its semi complex. The box associated with
            //the inference is ALWAYS responsible for sending the intial message of a positive
            //integer which represents its position within the foreach loop, this function of sending
            //said value will NOT be coded into the box, and it is up to whoever implements the box
            //that on tap of said box the info is sent. It is then up to the specific graph view to
            //send the message that it should be destructed. It is best practice to specify in the
            //constructor of the view the amount of seconds which it should be visible.
            .onReceive(inferenceInFocusPub){message in
                if aggregateInference != nil {
                    print("GRAPHVIEW: recieved message")
                    aggregateInference!.objectInFocus = Int((message.object as! NSString).doubleValue)
                    objectInFocus = Int((message.object as! NSString).doubleValue)
                }
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
            let yPositions = genYvalues(data: data, ySize: height!, dataRange: dataRange, dataMin: dataMin)
            // Closest X value
            let closestXPoint = xPositions.enumerated().min( by: { abs($0.1 - touchPoint.0) < abs($1.1 - touchPoint.0) } )!
            let closestYPointIndex = xPositions.firstIndex(of: closestXPoint.element)!
            let closestYPoint = yPositions[closestYPointIndex]
            
            // Index of the closest points in the array
            let yPointIndex = closestYPointIndex
            

            return (closestXPoint.element, closestYPoint, yPointIndex)
        }
}
