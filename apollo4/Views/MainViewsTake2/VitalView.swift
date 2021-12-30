//
//  VitalView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI
//Our main view for viewing estimation data from algorithm chip
struct VitalView: View {
    //Data saved for stats
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    //Our bluetooth manager, only needed for writes, notifications are caught by the manager on its own
    @EnvironmentObject var bleManager: BLEManager
    //Used to call the live read UI
    @State var isReading = false
    //Debug option to use prettier SPO2 data than the shitty readings were getting now
    private var usingSPO2 : Bool = false
    //Stat objects
    private var HeartRateObject: StatDataObject{
        getStatDataObject(stats: Array(stats), name: "HeartRate")
    }
    private var SPO2Object: StatDataObject{
        getStatDataObject(stats: Array(stats), name: "SPO2")
    }
    private var SystolicPressureObject: StatDataObject{
        getStatDataObject(stats: Array(stats), name: "SystolicPressure")
    }
    private var DiastolicPressureObject: StatDataObject{
        getStatDataObject(stats: Array(stats), name: "DiastolicPressure")
    }
    var body: some View {
        ZStack(alignment: .top){
            //Not implemented yet but will be used to switch day of data being looked at
            dateSwitcher(dates: HeartRateObject.generateTupleData().map{$0.1})
                .zIndex(3)
            VStack{
                ScrollView{
                    //MainUIBox for each main stat
                    MainUIBox(title: HeartRateObject.name!, dataVal: HeartRateObject.data.last as! Double, dataValStr: String(HeartRateObject.data.last as! Double), imageName: "heart.fill", foregroundColor: Color.red, cardFunc: HeartRateCardSwitcher, numCards: 4, fullscreenData:
                                statViewData(name: "Heart Rate", tupleData: HeartRateObject.generateTupleData(), dataRange: HeartRate().getRange(label: "").1 - HeartRate().getRange(label: "").0, dataMin: HeartRate().getRange(label: "").0, gradient: Gradient(colors: [Color.orange, Color.pink]))){
                        LineGraph(data: .constant(HeartRateObject.slimData(to: 50, within: .day).map{$0.0}), dataTime: .constant(HeartRateObject.slimData(to: 50, within: .day).map{$0.1}), dataMin: 50, dataRange: 150, height: 250, width: 290, gradient: Gradient(colors: [Color.pink, Color.orange, Color.red]))
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
                            .padding(.leading, -10)
                            .id(0)
                        SegmentedRingChartView(stat: HeartRate(), dataList: filterDataTuples(forData: getStatDataObject(stats: Array(stats), name: "HeartRate").generateTupleData(), in: .day))
                            .frame(width: 200, height: 200)
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                            .id(1)
                    }
                                .padding(.top, 40)
                    MainUIBox(title: SPO2Object.name!, dataVal: SPO2Object.data.last as! Double, dataValStr: String(SPO2Object.data.last as! Double), imageName: "wind", foregroundColor: Color.white, cardFunc: SPO2CardSwitcher, numCards: 3, fullscreenData:
                                statViewData(name: "SPO2", tupleData: SPO2Object.generateTupleData(), dataRange: SPO2().getRange(label: "").1 - SPO2().getRange(label: "").0, dataMin: SPO2().getRange(label: "").0, gradient: Gradient(colors: [Color.blue, Color.purple]))){
                        VerticalLinePlotter(data: usingSPO2 ? SPO2Object.slimData(to: 30, within: .day) : genRandomData(), title: "Todays Readings", stat: SPO2(), width: UIScreen.main.bounds.size.width - 60, height: 300)
                            .padding()
                            .id(0)
                        VStack{
                            Text("This Weeks Average Level")
                                .font(.title2)
                                .foregroundColor(Color(UIColor.systemGray))
                                .padding(.horizontal)
                            RingChart(progress: .constant((averageData(data: SPO2Object.data.map{Double(truncating: $0)}) - SPO2().getRange(label: "").0)/(SPO2().getRange(label: "").1 - SPO2().getRange(label: "").0)), text: .constant(String(format: "%.01f", averageData(data: SPO2Object.data.map{Double(truncating: $0)}))))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                        .padding()
                        .id(1)
                    }
                    MainUIBox(title: "Blood Pressure", dataVal: 1.0, dataValStr: String(SystolicPressureObject.data.last as! Int) + "/" + String(DiastolicPressureObject.data.last as! Int), imageName: "thermometer", foregroundColor: Color.white, cardFunc: BPCardSwitcher, numCards: 3, fullscreenData:
                                statViewData(name: "Heart Rate", tupleData: HeartRateObject.generateTupleData(), dataRange: HeartRate().getRange(label: "").1 - HeartRate().getRange(label: "").0, dataMin: HeartRate().getRange(label: "").0, gradient: Gradient(colors: [Color.orange, Color.pink]))){
                        MultiLineGraph(data: .constant([SystolicPressureObject.slimData(to: 30, within: .day).map{$0.0}, DiastolicPressureObject.slimData(to: 30, within: .day).map{$0.0}]), dataWithLabels: .constant([SystolicPressureObject.slimData(to: 30, within: .day).map{$0.1}, DiastolicPressureObject.slimData(to: 30, within: .day).map{$0.1}]), height: 250, width: 290, gradients: [Gradient(colors: [Color.pink, Color.purple]), Gradient(colors: [Color.purple, Color.blue])], statNames: ["Systolic Pressure", "Diastolic Pressure"])
                            .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
                            .padding(.leading, -10)
                            .padding(.top, 10)
                            .id(0)
                        BPMiniLevelView(sysData: SystolicPressureObject.data.map{$0 as! Double}, diaData: DiastolicPressureObject.data.map{$0 as! Double})
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                            .id(1)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.bottom, 0.3)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.black]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 1.0)))
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
        case 0: return AnyView(CardView(name: "Heart Rate Variability", backgroundColor: Color.pink){
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .padding()
        })
        case 1: return AnyView(CardView(name: "Resting Heart Rate", backgroundColor: Color.blue){
            Image(systemName: "bed.double")
                .resizable()
                .padding()
        })
        case 2: return AnyView(CardView(name: "Live Read", backgroundColor: Color.green){
            Image(systemName: "bolt.heart")
                .resizable()
                .padding()
                .fullScreenCover(isPresented: $isReading){
                    LiveReadView()
                }
            .onTapGesture {
                isReading = true
            }
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
        case 1: return AnyView(CardView(name: "Pulse Pressure", backgroundColor: Color.green){
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
