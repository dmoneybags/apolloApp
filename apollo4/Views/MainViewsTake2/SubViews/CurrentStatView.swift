//
//  CurrentStatView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/7/22.
//

import SwiftUI

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

struct CurrentStatView: View {
    var stat: String
    var gradient: Gradient
    @State private var linearRegressionStr = ""
    @State private var up: Bool = true
    var body: some View {
        let statInfo = getStatInfoObject(named: stat)!
        BasicSettingView(title: "Current " + statInfo.displayName){
            HStack{
                Text(String(MostRecentValues.valueDict[stat]!))
                    .font(Font.system(size: 100, design: .monospaced))
                    .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    .frame(height: 150)
                Image(systemName: up ? "arrow.up": "arrow.down")
                    .resizable()
                    .frame(width: 40, height: 60)
                    .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            }
            Text(MostRecentValues.getTimeAgo(stat: stat) ?? "")
                    .foregroundColor(Color(UIColor.systemGray3))
                Divider()
            ScrollView{
                HStack{
                    Text(statInfo.getLabel(reading: 100.0))
                        .font(.title)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(gradient: progressToGradient(progress: getProgress(stat: stat, reading: 100.0)), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Spacer()
                }
                Text("\t Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .padding(.horizontal)
                    .foregroundColor(Color(UIColor.systemGray))
                Divider()
                HStack{
                    Text(linearRegressionStr)
                        .font(.title)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Spacer()
                }
                getGraphView(stat: stat)
            }
        }
        .onAppear{
            linearRegressionStr = getLinearRegressionStr()
        }
    }
    func getGraphView(stat: String) -> AnyView{
        let statObject = fetchSpecificStatDataObject(named: stat)
        let allData = statObject.generateTupleData()
        let filteredData = filterDataTuples(forData: allData, in: .hour)
        return AnyView(LineGraph(data: .constant(filteredData.map{$0.0}), dataTime: .constant(filteredData.map{$0.1}), height: 100, width: UIScreen.main.bounds.width - 30, gradient: gradient, title: "Last Hour", useLines: false, pooledData: false))
    }
    func getLinearRegressionStr() -> String {
        let statObject = fetchSpecificStatDataObject(named: stat)
        let data = statObject.generateTupleData()
        let filteredData = filterDataTuples(forData: data, in: .hour)
        let (slope, yIntercept) = calcLinearReg(data: filteredData.map{$0.0})
        if slope < 0 {
            withAnimation{
                up = false
            }
        }
        return String(abs(getTrendPercent(dataFirst: filteredData.first!.0, dataLen: filteredData.count, slope: slope, yIntercept: yIntercept))) + "% " + (slope > 0 ? "Up" : "Down")
    }
}

struct CurrentStatView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentStatView(stat: "SPO2", gradient: Gradient(colors: [.purple, .blue])).preferredColorScheme(.dark)
    }
}
func progressToGradient(progress: Double) -> Gradient {
    let inverseProg = 1 - progress
    switch inverseProg{
    case 0..<0.2: return Gradient(colors: [.purple, .blue])
    case 0.2..<0.5: return Gradient(colors: [.green, .blue])
    case 0.5..<0.7: return Gradient(colors: [.orange, .yellow])
    case 0.7..<10: return Gradient(colors: [.red, .orange])
    default: return Gradient(colors: [.red, .orange])
    }
}
struct CurrentBPView: View {
    @State private var linearRegressionStr = ""
    @State private var up: Bool = true
    var body: some View {
        BasicSettingView(title: "Current Blood Pressure"){
            HStack{
                VStack(spacing: 0.0) {
                    Text(String(MostRecentValues.valueDict["SystolicPressure"] ?? 0.0))
                        .font(Font.system(size: 100, design: .monospaced))
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(height: 150)
                    Capsule()
                        .frame(width: 200, height: 10)
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Text(String(MostRecentValues.valueDict["DiastolicPressure"] ?? 0.0))
                        .font(Font.system(size: 100, design: .monospaced))
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(height: 150)
                }
                Image(systemName: up ? "arrow.up": "arrow.down")
                    .resizable()
                    .frame(width: 40, height: 60)
                    .foregroundStyle(LinearGradient(colors: [.pink, .purple], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            }
            Text(MostRecentValues.getTimeAgo(stat: "SystolicPressure") ?? "")
                    .foregroundColor(Color(UIColor.systemGray3))
                Divider()
            ScrollView {
                let bpLabels = getBPLabel(systolicReading: MostRecentValues.valueDict["SystolicPressure"] ?? 0.0, diastolicReading: MostRecentValues.valueDict["DiastolicPressure"] ?? 0.0)
                HStack{
                    Text(bpLabels.0)
                        .font(.title)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Spacer()
                }
                Text("\t" + (HypertensionStruct.descriptionDict[bpLabels.0] ?? ""))
                    .padding(.horizontal)
                    .foregroundColor(Color(UIColor.systemGray))
                Divider()
                HStack{
                    Text(linearRegressionStr)
                        .font(.title)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                    Spacer()
                }
                getGraphView()
            }
        }
        .onAppear{
            linearRegressionStr = getLinearRegressionStr()
        }
    }
    func getLinearRegressionStr() -> String {
        let statObject = fetchSpecificStatDataObject(named: "SystolicPressure")
        let data = statObject.generateTupleData()
        let filteredData = filterDataTuples(forData: data, in: .hour)
        let (slope, yIntercept) = calcLinearReg(data: filteredData.map{$0.0})
        if slope < 0 {
            withAnimation{
                up = false
            }
        }
        return String(getTrendPercent(dataFirst: filteredData.first!.0, dataLen: filteredData.count, slope: slope, yIntercept: yIntercept)) + "% " + (slope > 0 ? "Up" : "Down")
    }
    func getGraphView() -> AnyView {
        let sysObj = fetchSpecificStatDataObject(named: "SystolicPressure")
        let diaObj = fetchSpecificStatDataObject(named: "DiastolicPressure")
        let sysFilteredData = filterDataTuples(forData: sysObj.generateTupleData(), in: .hour)
        let diaFilteredData = filterDataTuples(forData: diaObj.generateTupleData(), in: .hour)
        return AnyView(MultiLineGraph(data: .constant([sysFilteredData.map{$0.0}, diaFilteredData.map{$0.0}]), dataWithLabels: .constant([sysFilteredData.map{$0.1}, diaFilteredData.map{$0.1}]), height: 100, width: UIScreen.main.bounds.width - 30, gradients: [Gradient(colors: [.purple,.pink]), Gradient(colors: [.blue, .purple])], statNames: ["Systolic Pressure", "Diastolic Pressure"], title: "Last Hour", useLines: false))
    }
}
