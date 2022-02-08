//
//  GraphInference.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/6/22.
//

import Foundation
import SwiftUI
//Everytime a new inference is created it must be added to this list of it will not be checked
fileprivate let objectsToCheck: [InferenceObjectBase] = [Minimum(), Maximum(), Average(), Trend(), GoalBox(), AlertBox()]
fileprivate let multiLineObjectsToCheck: [MultiLineInferenceObjectBase] = [MultilineMinimum(), MultilineMaximum(), MultiLineAverage()]
//Object to hold multiple sets of data
struct aggregateDataObject {
    var statData : [String: [(Double, Date)]]
    //timeFrame and offset allow us to filter our data appropiately
    var timeFrame : Calendar.Component
    var offset : Int = 0
    init(stats: [StatDataObject], within givenTimeFrame: Calendar.Component){
        timeFrame = givenTimeFrame
        statData = [:]
        for stat in stats {
            print("GRAPHINFERENCE::Adding \(stat.name!) to statData")
            statData[stat.name!] = filterDataTuples(forData: stat.generateTupleData(), in: timeFrame, withOffset: offset)
        }
    }
}
protocol InferenceObjectBase: AnyObject {
    //Empty initializer will always be used, it is up to the aggregate Inference Object to call the in the instance with real data
    init()
    var title: String {get}
    var subTitle: String {get}
    //Box is what we will show as a box on the main graph view
    var box: AnyView {get}
    var data: [Double] {get}
    //What will appear on the graph
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView 
    //Takes in an aggregate Data object and evaluates whether or not the inference is valid
    //EX: a relaxation inference object evaluates when a users blood pressure and heart rate drop below a certain level and the time is between
    //11 am and 8pm, if no spans of data within the aggregate data object matches this, the function will return false
    //Ability to pass in one stat or list of stats, singular mainStat will always take preecedence over list
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool
    ///IN ALL HONESTY "FORSTATS" SHOULD ONLY BE USED FOR EXTREMELY CLOSELY RELATED STATISTICS, AND IS NOT MEANT TO BE USED FOR
    ///GARNERING GENERAL INFERENCES LIKE RELAXED, TIRED, ETC
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?)
}
protocol MultiLineInferenceObjectBase: AnyObject {
    init()
    var title: String {get}
    var subTitle: String {get}
    var box: AnyView {get}
    //What will appear on the graph
    func getGraphView(width: Double, height: Double, graphData: [[Double]], dataRange: Double?, dataMin: Double?, gradients: [Gradient]) -> AnyView
    func isValid(forStats stats: [String]?) -> Bool
    func populate(forStats stats: [String]?, graphData: [[(Double, Date)]])
}
//Will error if passed an improper main stat
class aggregateInferenceObject: ObservableObject{
    //mainStat is the main stat we are looking at. For example, if we want to make inferences based mainly on SPO2, to easily get values like min, max, and trend
    //we need a singular main stat to look for these values.
    var mainStat: String? = nil
    var objectsToImplement: [InferenceObjectBase] = []
    var multiLineObjectsToImplement: [MultiLineInferenceObjectBase] = []
    var timeFrame : Calendar.Component
    //Object in focus is an integer representing the inference which the user is focusing on
    @Published var objectInFocus : Int
    init(data: aggregateDataObject, forStat stat: String? = nil, graphData: [(Double, Date)]){
        objectInFocus = -1
        mainStat = stat
        timeFrame = data.timeFrame
        for inference in objectsToCheck{
            if inference.isValid(aggregateData: data, mainStat: mainStat) {
                inference.populate(aggregateData: data, mainStat: mainStat, timeFrame: timeFrame, graphData: graphData)
                objectsToImplement.append(inference)
            }
        }
    }
    init(forStats stats: [String]? = nil, graphData: [[(Double, Date)]]){
        objectInFocus = -1
        for inference in multiLineObjectsToCheck {
            if inference.isValid(forStats: stats){
                inference.populate(forStats: stats, graphData: graphData)
                multiLineObjectsToImplement.append(inference)
            }
        }
        //PLACEHOLDER, will likely either be set of be optional, depending on needs of subsequent
        timeFrame = .year
    }
    func setObjectInFocus(index: Int){
        objectInFocus = index
    }
}

struct InferenceBox<Content: View>: View {
    var title : String
    var subTitle: String
    var color: Color
    var imageName: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack{
            HStack {
                Text(title)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .padding(.leading, 20)
                Image(systemName: imageName)
                    .resizable()
                    .foregroundColor(color)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            Text(subTitle)
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray3))
                .padding(.bottom, -5)
            Divider()
            content
        }
        .background(Color(UIColor.black.withAlphaComponent(0.3)))
        .frame(width: UIScreen.main.bounds.size.width/2 - 30, height: 200)
        .cornerRadius(20)
    }
}
 
fileprivate class Minimum : InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    var minimum: Double
    var minIndex: Int
    var timeMin: Date
    required init(){
        title = ""
        subTitle = ""
        box = AnyView(EmptyView())
        data = []
        minimum = 0.0
        minIndex = 0
        timeMin = Date()
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceMinMaxGraphView(value: minimum, index: minIndex, dataRange: dataRange!, dataMin: dataMin!, graphData: graphData, width: width, height: height, color: Color.purple, gradient: Gradient(colors: [.green, .blue])))//.scaleEffect(CGSize(width: 1.0, height: -1.0)))
        //flip because graph is flipped (pls dont ask why)
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        return (mainStat != nil)
    }
    //This function will abort if mainstat is ever nil but this is ok because we make sure the mainstat
    //is not nil in the valid check
    //fix the padding and formatting for inference box to be a little bigger and us a color for the text
    //fix mainUIBox to pass an optional main stat to fullscreenView
    //fix the logic which causes the view to appear and disappear, probably a binding to lineGraph, of
    //the inferece object
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating minimum with data for \(mainStat!)")
        let mainData = aggregateData.statData[mainStat!]
        data = graphData!.map{$0.0}
        minimum = data.min()!
        let timeMinIndex = graphData!.map{$0.0}.firstIndex(of: minimum)
        minIndex = timeMinIndex!
        timeMin = graphData!.map{$0.1}[timeMinIndex!]
        title = "minimum"
        switch timeFrame{
        case .minute: subTitle = "over 15 minutes"
        case .hour: subTitle = "over an hour"
        case .day: subTitle = "over a day"
        case .month: subTitle = "over a month"
        default: subTitle = ""
        }
        box =
        AnyView(
            InferenceBox(title: title, subTitle: subTitle, color: .purple, imageName: "square.and.arrow.down.fill"){
                RingChart(progress: .constant(0.3), text: .constant(String(format: "%.1f", minimum)), color: .purple)
                    .padding()
                Text(getTimeComponent(date: timeMin, timeFrame: getTimeRangeVal(dates: mainData!.map{$0.1})))
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.systemGray3))
            }
        )
    }
}

fileprivate class Maximum: InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    var maximum: Double
    var maxIndex: Int
    var timeMax: Date
    required init() {
        title = ""
        subTitle = ""
        box = AnyView(EmptyView())
        data = []
        maximum = 0.0
        maxIndex = 0
        timeMax = Date()
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceMinMaxGraphView(value: maximum, index: maxIndex, dataRange: dataRange, dataMin: dataMin, graphData: graphData, width: width, height: height, color: Color.yellow, gradient: Gradient(colors: [.orange, .red]), isMin: false))
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        return (mainStat != nil)
    }
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating maximum with data for \(mainStat!)")
        let mainData = aggregateData.statData[mainStat!]
        data = graphData!.map{$0.0}
        maximum = data.max()!
        let timeMaxIndex = graphData!.map{$0.0}.firstIndex(of: maximum)
        maxIndex = timeMaxIndex!
        timeMax = graphData!.map{$0.1}[timeMaxIndex!]
        title = "maximum"
        switch timeFrame{
        case .minute: subTitle = "over 15 minutes"
        case .hour: subTitle = "over an hour"
        case .day: subTitle = "over a day"
        case .month: subTitle = "over a month"
        default: subTitle = ""
        }
        box =
        AnyView(
            InferenceBox(title: title, subTitle: subTitle, color: .yellow, imageName: "square.and.arrow.up.fill"){
                RingChart(progress: .constant(0.3), text: .constant(String(format: "%.1f", maximum)), color: .yellow)
                    .padding()
                Text(getTimeComponent(date: timeMax, timeFrame: getTimeRangeVal(dates: mainData!.map{$0.1})))
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.systemGray3))
            }
        )
    }
}

fileprivate class Average: InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    var average: Double
    var allTimeAverage: Double
    required init() {
        title = ""
        subTitle = ""
        box = AnyView(EmptyView())
        data = []
        average = 0.0
        allTimeAverage = 0.0
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceAverageGraphView(value: average, allTimeAverage: allTimeAverage, dataRange: dataRange, dataMin: dataMin, width: width, height: height))
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        return (mainStat != nil)
    }
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating average with data for \(mainStat!)")
        let mainData = aggregateData.statData[mainStat!]
        data = graphData!.map{$0.0}
        average = averageData(data: mainData!.map{$0.0})
        allTimeAverage = averageData(data: fetchSpecificStatDataObject(named: mainStat!).data.map{Double($0)})
        title = "average"
        box =
        AnyView(
            InferenceBox(title: title, subTitle: subTitle, color: Color.blue, imageName: "divide"){
                HStack{
                    TickMarkReader(length: 130, width: 30, stat: mainStat!, reading: average, color: .blue)
                    Text(String(format: "%.1f", average))
                        .font(.largeTitle)
                        .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                }
            }
        )
    }
}
fileprivate class Trend: InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    //slope
    var slope: Double
    //yIntercept
    var yIntercept: Double
    required init() {
        title = ""
        subTitle = ""
        box = AnyView(EmptyView())
        data = []
        slope = 0.0
        yIntercept = 0.0
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceTrendGraphView(slope: slope, yIntercept: yIntercept, data: data, dataRange: dataRange, dataMin: dataMin, height: height, width: width))
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        return (mainStat != nil)
    }
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating average with data for \(mainStat!)")
        let mainData = aggregateData.statData[mainStat!]
        data = graphData!.map{$0.0}
        slope = calcLinearReg(data: data).0
        yIntercept = calcLinearReg(data: data).1
        title = "trend"
        box =
        AnyView (
            InferenceBox(title: title, subTitle: subTitle, color: .pink, imageName: slope > 0 ? "arrow.up.right" : "arrow.down.right"){
                ZStack{
                    Line(start: CGPoint(x: 0.0, y: slope > 0 ? 65 : -65), end: CGPoint(x: 250, y: slope < 0 ? 65 : -65))
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.pink)
                        .frame(height: 1)
                    VStack{
                        if slope > 0 {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Up")
                                    .foregroundColor(.pink)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                            }
                            .padding()
                        } else {
                            HStack {
                                Spacer()
                                Text("Down")
                                    .foregroundColor(.pink)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    .frame(width: 200, height: 141, alignment: .center)
                }
                .frame(width: 250, height: 141, alignment: .center)
        }
        )
    }
}
fileprivate class GoalBox: InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    var goalSetting: GoalSetting?
    required init() {
        self.title = ""
        self.subTitle = ""
        self.box = AnyView(EmptyView())
        self.data = []
        self.goalSetting = nil
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceGoalBoxView(value: self.goalSetting!.value, above: self.goalSetting!.above, didHitGoal: getPercentOfTimeOnGoal() > 0.49, dataRange: dataRange, dataMin: dataMin, width: width, height: height))
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        let goalSetting = getGoalSetting(for: mainStat ?? "NOSTAT")
        return goalSetting != nil
    }
    func getPercentOfTimeOnGoal() -> Double{
        if self.goalSetting != nil {
            var numGoal: Double =  0
            for double in data{
                if (goalSetting!.above ? double > goalSetting!.value :  double < goalSetting!.value){
                    numGoal += 1
                }
            }
            return numGoal/Double(data.count)
        } else {
            return 0.0
        }
    }
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating GoalBox data for \(title)")
        self.title = "Goal Progress"
        self.data = graphData!.map({$0.0})
        self.goalSetting = getGoalSetting(for: mainStat ?? "NOSTAT")
        self.box = AnyView(
            InferenceBox(title: self.title, subTitle: self.subTitle, color: .orange, imageName: "checkmark.seal"){
                Text(String(format: "%.01f", getPercentOfTimeOnGoal() * 100) + "%")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(LinearGradient(colors: [Color.pink, Color.orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                Spacer()
                Text("of the time you are hitting your most recent goal.")
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.systemGray3))
                    .scaleEffect(0.7)
            }
        )
    }
}
fileprivate class AlertBox: InferenceObjectBase {
    var title: String
    var subTitle: String
    var stat: String
    var box: AnyView
    var data: [Double]
    var times: [Date]
    var tupleData: [(Double, Date)]
    var alerts: [(Double, Date)]
    var timeFrame: Calendar.Component
    var notification: NotificationSetting?
    required init() {
        self.title = ""
        self.subTitle = ""
        self.stat = ""
        self.box = AnyView(EmptyView())
        self.data = []
        self.times = []
        self.tupleData = []
        self.alerts = []
        self.timeFrame = .day
        self.notification = nil
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceAlertGraphView(value: notification!.value, graphData: self.tupleData, alerts: self.alerts, pooledAlerts: getAlerts(timeFrame: self.timeFrame, stat: self.stat, aggregateTupleData: self.tupleData), above: notification!.above, dataRange: dataRange!, dataMin: dataMin!, width: width, height: height))
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        let notificationSetting = getNotificationSetting(for: mainStat ?? "NOSTAT")
        return notificationSetting != nil
    }
    func getAlerts(timeFrame: Calendar.Component, stat: String, aggregateTupleData: [(Double, Date)]? = nil) -> [(Double, Date)]{
        var usedTupleData: [(Double, Date)] = []
        if aggregateTupleData != nil {
            usedTupleData = aggregateTupleData!
        } else{
            usedTupleData = filterDataTuples(forData: fetchSpecificStatDataObject(named: stat).generateTupleData(), in: timeFrame)
        }
        var alerts: [(Double, Date)] = []
        var inAlertZone = false
        var prevTime = TimeInterval(0)
        for tuple in usedTupleData{
            if (notification!.above ? tuple.0 > notification!.value : tuple.0 < notification!.value) && !inAlertZone{
                alerts.append(tuple)
                inAlertZone = true
                prevTime = tuple.1.timeIntervalSince1970
            } else {
                if (notification!.above ? tuple.0 < notification!.value : tuple.0 > notification!.value){
                    inAlertZone = false
                }
            }
        }
        print("GRAPHINFERENCE::FOUND ALERTS OF \(alerts)")
        return alerts
    }
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("GRAPHINFERENCE::Populating AlertBox data for \(title)")
        self.title = "Alerts Triggered"
        self.subTitle = ""
        self.stat = mainStat!
        self.data = graphData!.map{$0.0}
        self.times = graphData!.map{$0.1}
        self.tupleData = graphData!
        self.notification = getNotificationSetting(for: mainStat!)
        self.timeFrame = timeFrame
        self.alerts = getAlerts(timeFrame: self.timeFrame, stat: self.stat)
        print("GRAPHINFERENCE::notification timeframe \(timeFrame)")
        self.box = AnyView(
            InferenceBox(title: self.title, subTitle: self.subTitle, color: .red, imageName: "exclamationmark.circle"){
                Spacer()
                HalfRingChart(minimum: 0, rangeVal: 20, reading: Double(self.alerts.count), colorVal: nil, gradient: Gradient(colors: [.clear, .red]), moving: .constant(false))
                    .scaleEffect(0.8)
                    .onAppear(){
                        print("GRAPHINFERENCE:: on appear number of alers is \(self.alerts.count)")
                    }
                Text("Over the \(GoalView.getDateStr(timeFrame: timeFrame))")
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.systemGray3))
                    .padding(.top, -30)
            }
        )
    }
}
fileprivate class MultilineMinimum: MultiLineInferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var stats: [String]
    var data: [[Double]]
    //Minimums are each individual minimum
    var minimums: [Double]
    //aggregate minimum is the point at which the two points are simutaineaously at their lowest value
    var aggregateMinimum: [Double]
    var minIndex: Int
    var timeMin: Date
    required init() {
        title = "minimum"
        subTitle = ""
        box = AnyView(EmptyView())
        stats = []
        data = []
        minimums = []
        aggregateMinimum = []
        minIndex = 0
        timeMin = Date()
    }
    func getGraphView(width: Double, height: Double, graphData: [[Double]], dataRange: Double?, dataMin: Double?, gradients: [Gradient]) -> AnyView {
        print("GRAPHINFERENCE::Retrieving multiLine minimum view")
        return AnyView(MultilineMinMaxGraphview(width: width, height: height, graphData: graphData, aggregateMin: aggregateMinimum, minIndex: minIndex, gradients: gradients))
    }
    func isValid(forStats stats: [String]?) -> Bool {
        return (stats != nil)
    }
    func populate(forStats stats: [String]?, graphData: [[(Double, Date)]]) {
        if stats!.count == 2 && stats!.first(where: {$0 == "SystolicPressure"}) != nil && stats!.first(where: {$0 == "DiastolicPressure"}) != nil {
            subTitle = "Blood Pressure"
        }
        setMinValues(graphData: graphData)
        print("GRAPHINFERENCE::Populating multiline data for \(title)")
        box =
        AnyView(
            InferenceBox(title: title, subTitle: "", color: .purple, imageName: "square.and.arrow.down.fill"){
                HStack{
                    ZStack{
                        VStack{
                            RingChart(progress: .constant(0.4), text: .constant(""), color: .purple)
                                .frame(width: 90, height: 90)
                            Spacer()
                        }
                        .frame(width: 100, height: 100)
                        VStack(spacing: 0.0){
                            Text(String(format: "%0.1f", aggregateMinimum[0]))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                                //.foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            Divider()
                                .padding(.horizontal, 30)
                                .frame(height: 3.0)
                            Text(String(format: "%.01f", aggregateMinimum[1]))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                                //.foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        }
                        .frame(width: 100)
                        .zIndex(2)
                        VStack{
                            Spacer()
                            Text(getTimeComponent(date: graphData[0].map{$0.1}[minIndex], timeFrame: getTimeRangeVal(dates: graphData[0].map{$0.1})))
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width/2 - 30)
                        /*
                        VStack{
                            Text(stats![0] + " minimum")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                            Divider()
                                .padding(.horizontal, 30)
                            Text(String(Int(minimums[0])))
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            HorizontalCapsuleReader(progress: getProgress(stat: stats![0], reading: minimums[0]), width: 60, height: 10, gradient: Gradient(colors: [.pink, .blue, .purple]))
                                .padding(0)
                            Divider()
                            Text(stats![1] + " minimum")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                            Divider()
                                .padding(.horizontal, 30)
                            Text(String(Int(minimums[1])))
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            HorizontalCapsuleReader(progress: getProgress(stat: stats![1], reading: minimums[1]), width: 60, height: 10, gradient: Gradient(colors: [.pink, .blue, .purple]))
                                .padding(0)
                        }
                        .frame(width: UIScreen.main.bounds.size.width/2 - 30)
                         */
                }
                .frame(height: 140)
            }
        )
    }
    private func setMinValues(graphData: [[(Double, Date)]]) {
        aggregateMinimum = []
        var minValue: Double = 100000
        var numStats = graphData.count
        print("GRAPHINFERENCE::numStats \(numStats)")
        var mins = [Double](repeating: 100000, count: numStats)
        for i in 0..<graphData[0].count{
            var testVal: Double = 0
            for j in 0..<numStats{
                testVal += graphData[j][i].0
                if graphData[j][i].0 < mins[j]{
                    mins[j] = graphData[j][i].0
                }
            }
            if testVal < minValue{
                minIndex = i
                minValue = testVal
            }
        }
        minimums = mins
        for i in 0..<numStats {
            aggregateMinimum.append(graphData[i][minIndex].0)
            
        }
        timeMin = graphData[0][minIndex].1
    }
}
fileprivate class MultilineMaximum: MultiLineInferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var stats: [String]
    var data: [[Double]]
    //Minimums are each individual minimum
    var maximums: [Double]
    //aggregate minimum is the point at which the two points are simutaineaously at their lowest value
    var aggregateMaximums: [Double]
    var maxIndex: Int
    var timeMax: Date
    required init() {
        title = "maximum"
        subTitle = ""
        box = AnyView(EmptyView())
        stats = []
        data = []
        maximums = []
        aggregateMaximums = []
        maxIndex = 0
        timeMax = Date()
    }
    func getGraphView(width: Double, height: Double, graphData: [[Double]], dataRange: Double?, dataMin: Double?, gradients: [Gradient]) -> AnyView {
        print("GRAPHINFERENCE::Retrieving multiLine minimum view")
        return AnyView(MultilineMinMaxGraphview(width: width, height: height, graphData: graphData, aggregateMin: aggregateMaximums, minIndex: maxIndex, gradients: gradients))
    }
    func isValid(forStats stats: [String]?) -> Bool {
        return (stats != nil)
    }
    func populate(forStats stats: [String]?, graphData: [[(Double, Date)]]) {
        if stats!.count == 2 && stats!.first(where: {$0 == "SystolicPressure"}) != nil && stats!.first(where: {$0 == "DiastolicPressure"}) != nil {
            subTitle = "Blood Pressure"
        }
        setMaxValues(graphData: graphData)
        print("GRAPHINFERENCE::Populating multiline data for \(title)")
        box =
        AnyView(
            InferenceBox(title: title, subTitle: "", color: .yellow, imageName: "square.and.arrow.up.fill"){
                HStack{
                    ZStack{
                        VStack{
                            RingChart(progress: .constant(0.8), text: .constant(""), color: .yellow)
                                .frame(width: 90, height: 90)
                            Spacer()
                        }
                        .frame(width: 100, height: 100)
                        VStack(spacing: 0.0){
                            Text(String(format: "%0.1f", aggregateMaximums[0]))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                                //.foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            Divider()
                                .padding(.horizontal, 30)
                                .frame(height: 3.0)
                            Text(String(format: "%.01f", aggregateMaximums[1]))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                                //.foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        }
                        .frame(width: 100)
                        .zIndex(2)
                        VStack{
                            Spacer()
                            Text(getTimeComponent(date: graphData[0].map{$0.1}[maxIndex], timeFrame: getTimeRangeVal(dates: graphData[0].map{$0.1})))
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width/2 - 30)
                        /*
                        VStack{
                            Text(stats![0] + " minimum")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                            Divider()
                                .padding(.horizontal, 30)
                            Text(String(Int(minimums[0])))
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            HorizontalCapsuleReader(progress: getProgress(stat: stats![0], reading: minimums[0]), width: 60, height: 10, gradient: Gradient(colors: [.pink, .blue, .purple]))
                                .padding(0)
                            Divider()
                            Text(stats![1] + " minimum")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                            Divider()
                                .padding(.horizontal, 30)
                            Text(String(Int(minimums[1])))
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                            HorizontalCapsuleReader(progress: getProgress(stat: stats![1], reading: minimums[1]), width: 60, height: 10, gradient: Gradient(colors: [.pink, .blue, .purple]))
                                .padding(0)
                        }
                        .frame(width: UIScreen.main.bounds.size.width/2 - 30)
                         */
                }
                .frame(height: 140)
            }
        )
    }
    private func setMaxValues(graphData: [[(Double, Date)]]) {
        aggregateMaximums = []
        var maxValue: Double = -1
        var numStats = graphData.count
        print("GRAPHINFERENCE::numStats \(numStats)")
        var maxs = [Double](repeating: -1, count: numStats)
        for i in 0..<graphData[0].count{
            var testVal: Double = 0
            for j in 0..<numStats{
                testVal += graphData[j][i].0
                if graphData[j][i].0 > maxs[j]{
                    maxs[j] = graphData[j][i].0
                }
            }
            if testVal > maxValue{
                maxIndex = i
                maxValue = testVal
            }
        }
        maximums = maxs
        for i in 0..<numStats {
            aggregateMaximums.append(graphData[i][maxIndex].0)
            
        }
        timeMax = graphData[0][maxIndex].1
    }
}
fileprivate class MultiLineAverage: MultiLineInferenceObjectBase {
    var title: String = "average"
    var subTitle: String
    var box: AnyView
    var stats: [String]
    //List of averages in same order as stats
    var averages: [Double]
    //List of all time averages in sane order as stats
    var aggregateAverages: [Double]
    required init() {
        subTitle = ""
        box = AnyView(EmptyView())
        stats = []
        averages = []
        aggregateAverages = []
    }
    func getGraphView(width: Double, height: Double, graphData: [[Double]], dataRange: Double?, dataMin: Double?, gradients: [Gradient]) -> AnyView {
        return AnyView(MultilineAverageGraphView(width: width, height: height, dataRange: getRange(data: graphData[0] + graphData[1]), dataMin: getMin(data: graphData[0] + graphData[1]), averages: averages, aggregateAverages: aggregateAverages, gradients: gradients + [Gradient(colors: [.green, .blue]), Gradient(colors: [.purple, .red])], statNames: ["Systolic Pressure", "Diastolic Pressure", "All time Systolic", "All time Diastolic"]))
    }
    func isValid(forStats stats: [String]?) -> Bool {
        return (stats != nil)
    }
    func populate(forStats stats: [String]?, graphData: [[(Double, Date)]]) {
        self.stats = stats!
        averages = []
        var iterator = 0
        for stat in self.stats{
            averages.append(averageData(data: graphData[iterator].map{$0.0}))
            iterator += 1
        }
        aggregateAverages = []
        for stat in self.stats{
            let statDataObject = fetchSpecificStatDataObject(named: stat)
            aggregateAverages.append(averageData(data: statDataObject.data.map{$0 as! Double}))
        }
        box =
        AnyView(
        InferenceBox(title: title, subTitle: subTitle, color: .blue, imageName: "divide"){
            VStack{
                ForEach(self.stats.indices, id: \.self){i in
                    if i != 0{
                        Divider()
                            .padding(.horizontal)
                    }
                    HStack(spacing: 5){
                        Spacer()
                        Text(String(format: "%.01f", self.averages[i]))
                                .font(.title)
                                .foregroundColor(.blue)
                        Spacer()
                        TickMarkReader(length: 40, width: 8, stat: self.stats[i], reading: self.averages[i], showNum: false)
                            .padding(.trailing, 15)
                    }
                }
            }
            .frame(height: 140)
        }
        )
    }
}
