//
//  VitalView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct VitalView: View {
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    private var usingSPO2 : Bool = false
    var HeartRateObject: StatDataObject{
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
        ZStack{
            VStack{
                ScrollView{
                    MainUIBox(statObject: HeartRateObject, imageName: "heart.fill", foregroundColor: Color.red, cardFunc: HeartRateCardSwitcher, numCards: 4){
                        LineGraph(data: .constant(HeartRateObject.slimData(to: 50, within: .day).map{$0.0}), dataTime: .constant(HeartRateObject.slimData(to: 50, within: .day).map{$0.1}), height: 250, width: 290, gradient: Gradient(colors: [Color.pink, Color.orange, Color.red]))
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
                            .padding(.leading, -10)
                            .id(0)
                        SegmentedRingChartView(stat: HeartRate(), dataList: filterDataTuples(forData: getStatDataObject(stats: Array(stats), name: "HeartRate").generateTupleData(), in: .day))
                            .frame(width: 200, height: 200)
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                            .id(1)
                    }
                    MainUIBox(statObject: getStatDataObject(stats: Array(stats), name: "SPO2"), imageName: "wind", foregroundColor: Color.white, cardFunc: SPO2CardSwitcher, numCards: 3){
                        VerticalLinePlotter(data: usingSPO2 ? SPO2Object.slimData(to: 30, within: .day) : genRandomData(), title: "Todays Readings", stat: SPO2(), width: UIScreen.main.bounds.size.width - 60, height: 300)
                            .padding()
                            .id(0)
                        VStack{
                            Text("This Weeks Average Level")
                                .font(.title2)
                                .foregroundColor(Color(UIColor.systemGray))
                                .padding(.horizontal)
                            RingChart(progress: .constant((averageData(data: SPO2Object.data.map{Double($0)}) - SPO2().getRange(label: "").0)/(SPO2().getRange(label: "").1 - SPO2().getRange(label: "").0)), text: .constant(String(format: "%.01f", averageData(data: SPO2Object.data.map{Double($0)}))))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 20, height: 300, alignment: .center)
                        .padding()
                        .id(1)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.bottom, 0.3)
            .background(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.black]), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 1.0)))
        }
    }
    fileprivate func genRandomData() -> [(Double, Date)]{
        var randomData: [(Double, Date)] = []
        for i in 0..<30{
            let randomDecider = Int.random(in: 0..<3)
            if randomDecider == 1{
                randomData.append((100.0, Date()))
            } else {
                randomData.append((95.0 + Double.random(in: 0..<5), Date()))
            }
        }
        return randomData
    }
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
        })
        case 3: return AnyView(CardView(name: "Set a Goal", backgroundColor: Color.purple){
            Image(systemName: "checkmark.seal")
                .resizable()
                .padding()
                .foregroundStyle(LinearGradient(colors: [Color.pink, Color.orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
        })
        default: return AnyView(EmptyView())
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
        default: return AnyView(EmptyView())
        }
    }
}

struct VitalView_Previews: PreviewProvider {
    static var previews: some View {
        VitalView()
    }
}
