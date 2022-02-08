//
//  GoalView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/27/22.
//

import SwiftUI
import NotificationBannerSwift

struct GoalView: View {
    @ObservedObject var twoWayProgress: ObservableDouble = ObservableDouble(val: 0.0)
    var statInfoObject: Stat
    @State private var above: Bool = false
    @State private var timeFrame: Calendar.Component = .weekOfYear
    private let successBanner = NotificationBanner(title: "Success", subtitle: "Goal set", style: .success)
    var body: some View {
        VStack{
            ScrollView{
                Text("For " + statInfoObject.displayName + ":")
                Divider()
                    .padding(.horizontal, 50)
                Section(header: Text("I want it to be:")){
                    Picker("", selection: $above){
                        Text("Above").tag(true)
                        Text("Below").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.blue)
                    .padding()
                    HalfRingChart(statVal: statInfoObject, reading: getGoodGoal(), moving: .constant(true), twoWayProgressVal: twoWayProgress)
                        .frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.width - 120)
                        .padding()
                    VStack{
                        Divider()
                        HStack{
                            Text("TimeFrame: ")
                            Picker("Average time frame:", selection: $timeFrame){
                                Text("Hour").tag(Calendar.Component.hour)
                                Text("Day").tag(Calendar.Component.day)
                                Text("Week").tag(Calendar.Component.weekOfYear)
                            }
                        }
                        Divider()
                    }
                    .padding(.top,  -70)
                    Text("Goal Summary")
                        .font(.title)
                        .foregroundStyle(LinearGradient(colors: [.blue, .green], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                    Divider()
                        .padding(.horizontal, 50)
                    HStack(spacing: 0){
                        Text("I want my ")
                        Text(statInfoObject.displayName)
                            .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        Text(" to be \(above ? "above " : "below ")")
                        Text(String(format: "%.01f",getReadingFromProgress()))
                            .font(Font.system(.body, design: .monospaced))
                            .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                    }
                    HStack(spacing: 0){
                        Text("for the ")
                        Text("\(GoalView.getDateStr(timeFrame: timeFrame)).")
                            .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                    }
                }
            }
            Button{
                setGoal(goalSetting: GoalSetting(value: getReadingFromProgress(), above: above, timeInterval: timeFrame, stat: statInfoObject))
                successBanner.show()
            } label: {
                HStack{
                    Text("Save")
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    func getReadingFromProgress() -> Double {
        let range = statInfoObject.getRange(label: "")
        let rangeVal = range.1 - range.0
        return Double(statInfoObject.minVal) + (twoWayProgress.value * rangeVal)
    }
    func getGoodGoal() -> Double{
        let ranges = statInfoObject.labels
        return statInfoObject.getRange(label: statInfoObject.labels[0]).1
    }
    static func getDateStr(timeFrame: Calendar.Component) -> String{
        switch timeFrame{
        case .hour: return "hour"
        case .day: return "day"
        case .weekOfYear: return "week"
        case .month: return "month"
        case .year: return "year"
        default: return "day"
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        BasicSettingView(title: "Set a Goal"){
            GoalView(statInfoObject: HeartRate.shared).preferredColorScheme(.dark)
        }
        .background(LinearGradient(colors: [.purple.opacity(0.5), .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
    }
}
