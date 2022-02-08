//
//  VitalView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//
import SwiftUI
//Our main view for viewing estimation data from algorithm chip
struct VitalView: View {
    //Our bluetooth manager, only needed for writes, notifications are caught by the manager on its own
    @EnvironmentObject var bleManager: BLEManager
    @AppStorage("APPEARANCE:MAINBACKGROUND") var bgColor: Color = .purple
    @StateObject private var offset: Offset = Offset(num: 0)
    @State private var HeartRateGraphData: [Double] = [Double](repeating: 60, count: 50)
    @State private var SPO2GraphData: [Double] = [Double](repeating: 0, count: 30)
    @State private var SysGraphData: [Double] = [Double](repeating: 0, count: 50)
    @State private var DiaGraphData: [Double] = [Double](repeating: 0, count: 50)
    @State private var HeartRateGraphTimes: [Date]? = [Date(timeIntervalSince1970: 1000), Date()]
    @State private var SPO2GraphTimes: [Date] = [Date(timeIntervalSince1970: 1000), Date()]
    @State private var SysGraphTimes: [Date] = [Date(timeIntervalSince1970: 1000), Date()]
    @State private var DiaGraphTimes: [Date] = [Date(timeIntervalSince1970: 1000), Date()]
    @State private var HeartRateTuples: [(Double, Date)] = [(1.0, Date(timeIntervalSince1970: 1000)), (1.0, Date())]
    @State private var SPO2Tuples: [(Double, Date)] = [(1.0, Date(timeIntervalSince1970: 1000)), (1.0, Date())]
    @State private var SysTuples: [(Double, Date)] = [(1.0, Date(timeIntervalSince1970: 1000)), (1.0, Date())]
    @State private var DiaTuples: [(Double, Date)] = [(1.0, Date(timeIntervalSince1970: 1000)), (1.0, Date())]
    @State private var BPData: [[Double]] = [[0.0, 1.0], [0.0, 1.0]]
    @State private var BPTimes: [[Date]]? = [[Date(timeIntervalSince1970: 1000), Date()], [Date(timeIntervalSince1970: 1000), Date()]]
    @State private var refreshing: Bool = false
    @State private var finishedRefresh: Bool = true
    @State private var HeartRateObject: StatDataObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "HeartRate")
    @State private var SPO2Object: StatDataObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "SPO2")
    @State private var SystolicPressureObject: StatDataObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "SystolicPressure")
    @State private var DiastolicPressureObject: StatDataObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "DiastolicPressure")
    var body: some View {
        ZStack(alignment: .top){
            //Not implemented yet but will be used to switch day of data being looked at
            if HeartRateObject.generateTupleData().map{$0.1}.count > 2 {
                DateSwitcher(dates: HeartRateObject.generateTupleData().map{$0.1})
                    .environmentObject(offset)
                    .zIndex(3)
                    .offset(x: 0, y: 55)
            }
            VStack{
                ScrollView{
                    Text("")
                    //best solution we could get was to just cancel out width with neegative padding
                        .frame(width: 10)
                        .padding(.trailing, -10)
                        .background(
                            GeometryReader { proxy in
                                Color.red
                                    .preference(
                                        key: OffsetPreferenceKey.self,
                                        value: proxy.frame(in: .named("VITALVIEW")).minY
                                    )
                            })
                    LazyVStack{
                        if refreshing {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                                .offset(y: 30)
                                .scaleEffect(1.2)
                        }
                        MainUIBox(title: "Blood Pressure", dataVal: 1.0, dataValStr: String((SystolicPressureObject.data.last?.intValue ?? 0)) + "/" + String((DiastolicPressureObject.data.last?.intValue ?? 0)), imageName: "thermometer", foregroundColor: Color.white, numScrollViews: 2, stats: [SystolicPressure(), DiastolicPressure()], fullscreenData:
                                    statViewData(name: "Blood Pressure", multiTupleData: [SystolicPressureObject.generateTupleData(), DiastolicPressureObject.generateTupleData()]), cardData: BPCards.list, content: {
                            MultiLineGraph(data: $BPData, dataWithLabels: $BPTimes, height: 250, width: UIScreen.main.bounds.size.width - 90, gradients: [Gradient(colors: [Color.pink, Color.purple]), Gradient(colors: [Color.purple, Color.blue])], statNames: ["Systolic Pressure", "Diastolic Pressure"])
                                .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
                                .padding(.leading, -10)
                                .padding(.top, 10)
                                .id(0)
                            BPMiniLevelView(sysData: $SysGraphData, diaData: $DiaGraphData)
                                .frame(width: UIScreen.main.bounds.size.width - 20, height: 365.5, alignment: .center)
                                .id(1)
                        })
                        .padding(.top, 40)
                        MainUIBox(title: HeartRateObject.name!, dataVal: HeartRateObject.data.last as? Double ?? 0.0, dataValStr: String(format: "%.01f", HeartRateObject.data.last as? Double ?? 0.0), imageName: "heart.fill", foregroundColor: Color.red, numScrollViews: 2, stats: [HeartRate()], fullscreenData:
                                    statViewData(name: "Heart Rate", statName: "HeartRate", tupleData: HeartRateObject.generateTupleData(), dataRange: HeartRate().getRange(label: "").1 - HeartRate().getRange(label: "").0, dataMin: HeartRate().getRange(label: "").0, gradient: Gradient(colors: [Color.orange, Color.pink])), cardData: HeartRateCards.list, content: {
                            LineGraph(data: $HeartRateGraphData, dataTime: $HeartRateGraphTimes, dataMin: 50, dataRange: 150, height: 250, width: UIScreen.main.bounds.size.width - 90, gradient: Gradient(colors: [Color.pink, Color.orange, Color.red]))
                                .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
                                .padding(.leading, -10)
                                .id(0)
                            HeartRateSegmentedChartView(stat: HeartRate.shared, tuples: HeartRateTuples)
                                .id(1)
                        })
                        MainUIBox(title: SPO2Object.name!, dataVal: SPO2Object.data.last as? Double ?? 0.0, dataValStr: String(format: "%.01f", SPO2Object.data.last as? Double ?? 0.0), imageName: "wind", foregroundColor: Color.white, numScrollViews: 2, stats: [SPO2()], fullscreenData:
                                    statViewData(name: "SPO2", statName: "SPO2", tupleData: SPO2Object.generateTupleData(), dataRange: 25, dataMin: 75, gradient: Gradient(colors: [Color.blue, Color.purple])), cardData: SPO2Cards.list, content: {
                            VerticalLinePlotter(data: $SPO2Tuples, title: "Day's Readings", stat: SPO2(), width: UIScreen.main.bounds.size.width - 60, height: 300)
                                .padding()
                                .id(0)
                            SPO2LevelView(SPO2Data: $SPO2GraphData)
                                .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                                .padding()
                                .id(1)
                        })
                    }
                    .offset(x: 0, y: 55)
                    .padding(.bottom, 100)
                }
                .coordinateSpace(name: "VITALVIEW")
                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                    DispatchQueue(label: "serial.queue").async {
                        if value >  50 && finishedRefresh{
                            print("VITALVIEW::CALLING REFRESH")
                            finishedRefresh = false
                            refreshing = true
                            StatDataObjectListWrapper.update(){success in
                                sleep(1)
                                HeartRateObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "HeartRate")
                                SPO2Object = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "SPO2")
                                SystolicPressureObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "SystolicPressure")
                                DiastolicPressureObject = getStatDataObject(stats: StatDataObjectListWrapper.stats, name: "DiastolicPressure")
                                refreshData(value: 0)
                                refreshing = false
                            }
                        }
                        if value <= 0{
                            finishedRefresh = true
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.bottom, 0.3)
            .background(LinearGradient(gradient: Gradient(colors: [bgColor, Color.black]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 1.0)))
            .onAppear(){
                withAnimation(){
                    print("Loading offset")
                    refreshData(value: 0)
                }
            }
        }
        .onAppear(){
            StatDataObjectListWrapper.update(){success in
            }
        }
        .onChange(of: offset.num){value in
            print("Reading offset of: \(value)")
            withAnimation(){
                print("Loading new offset")
                refreshData(value: value)
            }
        }
    }
    func refreshData(value: Int){
        HeartRateGraphData = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.0}
        HeartRateGraphTimes = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.1}
        SPO2GraphData = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: value).map{$0.0}
        SPO2GraphTimes = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: value).map{$0.1}
        SysGraphData = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.0}
        SysGraphTimes = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.1}
        DiaGraphData = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.0}
        DiaGraphTimes = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value).map{$0.1}
        HeartRateTuples = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: value)
        SPO2Tuples = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: value)
        SysTuples = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value)
        DiaTuples = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: value)
        BPData = [SysGraphData, DiaGraphData]
        BPTimes = [SysGraphTimes, DiaGraphTimes]
    }
}
