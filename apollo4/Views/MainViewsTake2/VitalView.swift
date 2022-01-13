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
    //Data saved for stats
    @StateObject var statsWrapper: StatDataObjectListWrapper = StatDataObjectListWrapper()
    //Offset for date picker
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
    private var HeartRateObject: StatDataObject {
        return getStatDataObject(stats: Array(statsWrapper.stats), name: "HeartRate")
    }
    private var SPO2Object: StatDataObject {
        return getStatDataObject(stats: Array(statsWrapper.stats), name: "SPO2")
    }
    private var SystolicPressureObject: StatDataObject {
        return getStatDataObject(stats: Array(statsWrapper.stats), name: "SystolicPressure")
    }
    private var DiastolicPressureObject: StatDataObject {
        return getStatDataObject(stats: Array(statsWrapper.stats), name: "DiastolicPressure")
    }
    var body: some View {
        ZStack(alignment: .top){
            //Not implemented yet but will be used to switch day of data being looked at
            DateSwitcher(dates: HeartRateObject.generateTupleData().map{$0.1})
                .environmentObject(offset)
                .zIndex(3)
            VStack{
                ScrollView{
                    //MainUIBox for each main stat
                    //Lazy VStack so they dont all load at once
                    LazyVStack{
                        MainUIBox(title: HeartRateObject.name!, dataVal: HeartRateObject.data.last as! Double, dataValStr: String(HeartRateObject.data.last as! Double), imageName: "heart.fill", foregroundColor: Color.red, cardFunc: HeartRateCardSwitcher, numCards: 4, numScrollViews: 2, stats: [HeartRate()], fullscreenData:
                                    statViewData(name: "Heart Rate", statName: "HeartRate", tupleData: HeartRateObject.generateTupleData(), dataRange: HeartRate().getRange(label: "").1 - HeartRate().getRange(label: "").0, dataMin: HeartRate().getRange(label: "").0, gradient: Gradient(colors: [Color.orange, Color.pink]))){
                            LineGraph(data: $HeartRateGraphData, dataTime: $HeartRateGraphTimes, dataMin: 50, dataRange: 150, height: 250, width: 290, gradient: Gradient(colors: [Color.pink, Color.orange, Color.red]))
                                .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
                                .padding(.leading, -10)
                                .id(0)
                            VStack{
                                Text("Daily Ranges")
                                    .font(.title2)
                                    .padding(.top)
                                    .foregroundColor(Color(UIColor.systemGray))
                                SegmentedRingChartView(stat: HeartRate(), dataList: HeartRateTuples)
                                    .frame(width: 170, height: 170)
                                    .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                            }
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
                            .id(1)
                        }
                        .environmentObject(statsWrapper)
                        .padding(.top, 40)
                        MainUIBox(title: SPO2Object.name!, dataVal: SPO2Object.data.last as! Double, dataValStr: String(SPO2Object.data.last as! Double), imageName: "wind", foregroundColor: Color.white, cardFunc: SPO2CardSwitcher, numCards: 3, numScrollViews: 2, stats: [SPO2()], fullscreenData:
                                    statViewData(name: "SPO2", statName: "SPO2", tupleData: SPO2Object.generateTupleData(), dataRange: 25, dataMin: 75, gradient: Gradient(colors: [Color.blue, Color.purple]))){
                            VerticalLinePlotter(data: $SPO2Tuples, title: "Todays Readings", stat: SPO2(), width: UIScreen.main.bounds.size.width - 60, height: 300)
                                .padding()
                                .id(0)
                            VStack{
                                Text("This Weeks Average Level")
                                    .font(.title2)
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .padding(.horizontal)
                                RingChart(progress: .constant((averageData(data: SPO2GraphData.map{Double(truncating: NSNumber(value: $0))}) - SPO2().getRange(label: "").0)/(SPO2().getRange(label: "").1 - SPO2().getRange(label: "").0)), text: .constant(String(format: "%.01f", averageData(data: SPO2Object.data.map{Double(truncating: $0)}))))
                                    .frame(width: 200, height: 200)
                            }
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                            .padding()
                            .id(1)
                        }
                        .environmentObject(statsWrapper)
                        MainUIBox(title: "Blood Pressure", dataVal: 1.0, dataValStr: String(SystolicPressureObject.data.last as! Int) + "/" + String(DiastolicPressureObject.data.last as! Int), imageName: "thermometer", foregroundColor: Color.white, cardFunc: BPCardSwitcher, numCards: 3, numScrollViews: 2, stats: [SystolicPressure(), DiastolicPressure()], fullscreenData:
                                    statViewData(name: "Blood Pressure", multiTupleData: [SystolicPressureObject.generateTupleData(), DiastolicPressureObject.generateTupleData()])){
                            MultiLineGraph(data: $BPData, dataWithLabels: $BPTimes, height: 250, width: 290, gradients: [Gradient(colors: [Color.pink, Color.purple]), Gradient(colors: [Color.purple, Color.blue])], statNames: ["Systolic Pressure", "Diastolic Pressure"])
                                .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
                                .padding(.leading, -10)
                                .padding(.top, 10)
                                .id(0)
                            BPMiniLevelView(sysData: $SysGraphData, diaData: $DiaGraphData)
                                .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                                .id(1)
                        }
                        .environmentObject(statsWrapper)
                    }
                    .padding(.bottom, 100)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.bottom, 0.3)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.black]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 1.0)))
            .onAppear(){
                withAnimation(){
                    HeartRateGraphData = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.0}
                    HeartRateGraphTimes = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.1}
                    SPO2GraphData = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: 0).map{$0.0}
                    SPO2GraphTimes = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: 0).map{$0.1}
                    SysGraphData = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.0}
                    SysGraphTimes = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.1}
                    DiaGraphData = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.0}
                    DiaGraphTimes = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0).map{$0.1}
                    HeartRateTuples = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: 0)
                    SPO2Tuples = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: 0)
                    SysTuples = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0)
                    DiaTuples = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: 0)
                    BPData = [SysGraphData, DiaGraphData]
                    BPTimes = [SysGraphTimes, DiaGraphTimes]
                }
            }
        }
        .onAppear(){
            statsWrapper.update()
        }
        .onChange(of: offset.num){offset in
            print("Reading offset of: \(offset)")
            withAnimation(){
                HeartRateGraphData = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.0}
                HeartRateGraphTimes = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.1}
                SPO2GraphData = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: offset).map{$0.0}
                SPO2GraphTimes = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: offset).map{$0.1}
                SysGraphData = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.0}
                SysGraphTimes = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.1}
                DiaGraphData = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.0}
                DiaGraphTimes = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset).map{$0.1}
                HeartRateTuples = slimDataTuples(forData: HeartRateObject.generateTupleData(), to: 50, within: .day, withOffset: offset)
                SPO2Tuples = slimDataTuples(forData: SPO2Object.generateTupleData(), to: 30, within: .day, withOffset: offset)
                SysTuples = slimDataTuples(forData: SystolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset)
                DiaTuples = slimDataTuples(forData: DiastolicPressureObject.generateTupleData(), to: 50, within: .day, withOffset: offset)
                BPData = [SysGraphData, DiaGraphData]
                BPTimes = [SysGraphTimes, DiaGraphTimes]
            }
        }
    }
    fileprivate func genRandomData() -> [(Double, Date)]{
        var randomData: [(Double, Date)] = []
        for _ in 0..<30{
            let randomDecider = Int.random(in: 0..<3)
            if randomDecider == 1{
                randomData.append((100.0, Date()))
            } else {
                randomData.append((95.0 + Double.random(in: 0..<5), Date()))
            }
        }
        return randomData
    }
    fileprivate func getGradient(forName name: String) -> Gradient {
        var colors : [Color]
        switch name {
        case "HeartRate": colors = [Color.pink, Color.orange]
        case "SPO2": colors = [Color.green, Color.blue]
        default: colors = []
        }
        return Gradient(colors: colors)
    }
    //Below functions are weird. They are used for the carousel below the mainUIboxes. It gives
    //an int and reeturns the card at that point.
    func HeartRateCardSwitcher(forIndex index: Int) -> AnyView {
        switch index {
        case 0: return AnyView(CardView(name: "Heart Rate Variability", backgroundColor: Color.pink, fullScreenView: AnyView(HrVarView())){
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .padding()
        })
        case 1: return AnyView(CardView(name: "Resting Heart Rate", backgroundColor: Color.blue, fullScreenView: AnyView(FullScreenStatInfo(tupleData: [getRestingHR(hrData: HeartRateObject.generateTupleData())], topText: "Resting Heart Rate", subText: "Resting heart rate is the hearts rate when not under abnormal stress or exertion", stats: [HeartRate()], colors: [.blue]))){
            Image(systemName: "bed.double")
                .resizable()
                .padding()
        })
        case 2: return AnyView(CardView(name: "Live Read", backgroundColor: Color.green, fullScreenView: AnyView(LiveReadView())){
            Image(systemName: "bolt.heart")
                .resizable()
                .padding()
        }
        )
        case 3: return AnyView(CardView(name: "Set a Goal", backgroundColor: Color.purple){
            Image(systemName: "checkmark.seal")
                .resizable()
                .padding()
                .foregroundStyle(LinearGradient(colors: [Color.pink, Color.orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
        })
        default: return AnyView(EmptyView().frame(width: 150, height: 200))
        }
    }
    func SPO2CardSwitcher(forIndex index: Int) -> AnyView {
        switch index{
        case 0: return AnyView(CardView(name: "VO2", backgroundColor: Color.green){
            RingChart(progress: .constant(0.5), text: .constant("60"), color: Color.blue)
                .padding()
        })
        case 1: return AnyView(CardView(name: "Raw Data", backgroundColor: Color(UIColor.systemGray3)){
            Image(systemName: "list.bullet")
                .resizable()
                .padding()
        })
        case 2: return AnyView(CardView(name: "Set a Goal", backgroundColor: Color.purple){
            Image(systemName: "checkmark.seal")
                .resizable()
                .padding()
                .foregroundStyle(LinearGradient(colors: [Color.pink, Color.orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
        })
        default: return AnyView(EmptyView().frame(width: 150, height: 200))
        }
    }
    func BPCardSwitcher(forIndex index: Int) -> AnyView {
        switch index{
        case 0: return AnyView(CardView(name: "Cardiac Output", backgroundColor: Color.orange){
            Image(systemName: "powerplug")
                .resizable()
                .padding()
        })
        case 1: return AnyView(CardView(name: "Pulse Pressure", backgroundColor: Color.green, fullScreenView: AnyView(FullScreenStatInfo(tupleData: [getPulsePressure(sysData: SystolicPressureObject.generateTupleData(), diaData: DiastolicPressureObject.generateTupleData())], topText: "Pulse Pressure", subText: "A measure of the difference between systolic and diastolic pressure", stats: [PulsePressure()], colors: [.green]))){
            Image(systemName: "dial.min")
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
        })
        case 2: return AnyView(CardView(name: "Set a Goal", backgroundColor: Color.purple){
            Image(systemName: "checkmark.seal")
                .resizable()
                .padding()
                .foregroundStyle(LinearGradient(colors: [Color.pink, Color.orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
        })
        default: return AnyView(EmptyView().frame(width: 150, height: 200))
        }
    }
}

struct VitalView_Previews: PreviewProvider {
    static var previews: some View {
        VitalView()
    }
}
