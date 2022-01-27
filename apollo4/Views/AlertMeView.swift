//
//  AlertMeView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/25/22.
//

import SwiftUI

fileprivate let stats: [Stat] = [DiastolicPressure.shared, HeartRate.shared, SystolicPressure.shared, SPO2.shared]
struct AlertMeView: View {
    var stats: [Stat]
    @ObservedObject private var progress = ObservableDouble(val: 0.0)
    @ObservedObject var secondProgress = ObservableDouble(val: 0.0)
    @State private var aboveOrBelow: [Bool]
    @State private var allowsMovement: Bool = true
    @State private var usesAverage: [Bool]
    @State private var timeFrame: [Calendar.Component]
    @State private var allowDefault: [Bool]
    public init(stats: [Stat]){
        self.stats = stats
        self.aboveOrBelow  = [Bool](repeating: true, count: stats.count)
        self.usesAverage = [Bool](repeating: false, count: stats.count)
        self.timeFrame = [Calendar.Component](repeating: .hour, count: stats.count)
        self.allowDefault = [Bool](repeating: false, count: stats.count)
    }
    var body: some View {
        VStack{
            ScrollView {
                ForEach(stats.indices, id: \.self){indice in
                    Section(header: Text("When \(stats[indice].displayName) is:")){
                        Picker("When stat is:", selection: $aboveOrBelow[indice]){
                            Text("Above").tag(true)
                            Text("Below").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .colorMultiply(.blue)
                        .padding()
                        HalfRingChart(statVal: stats[indice], reading: Double(stats[indice].maxVal) - Double(stats[indice].maxVal - stats[indice].minVal)/1.4, moving: $allowsMovement, twoWayProgressVal: indice  == 0 ? progress : secondProgress)
                            .frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.width - 120)
                            .padding()
                        VStack{
                            Text("Notify me when:")
                            Divider()
                            HStack{
                                Picker("Notify me when:", selection: $usesAverage[indice]){
                                    Text("Stat is measured beyond limit").tag(false)
                                    Text("Average over time frame is beyond limit").tag(true)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, -70)
                        Divider()
                        if usesAverage[indice] {
                            Picker("Average time frame:", selection: $timeFrame){
                                Text("Hour").tag(Calendar.Component.hour)
                                Text("Day").tag(Calendar.Component.day)
                                Text("Week").tag(Calendar.Component.weekOfYear)
                            }
                            Divider()
                        }
                        HStack{
                            Toggle("Allow default notifications: ", isOn: $allowDefault[indice])
                        }
                        .padding(.horizontal, 30)
                        Text("Default notifications are sent when a stat is measured to be a signifigant distance from your average level.")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                    }
                }
            }
            Button{
                print("AlertMeView::Saving...")
                var notificationSettings: [NotificationSetting] = []
                for indice in stats.indices{
                    notificationSettings.append(NotificationSetting(stat: stats[indice].name, value:  HalfRingChart.getReading(progressVal: indice == 0 ? progress.value : secondProgress.value, rangeVal: Double(stats[indice].maxVal - stats[indice].minVal), min: Double(stats[indice].minVal)), above: aboveOrBelow[indice], usesAverage: usesAverage[indice], averageTimeFrame: getNumSeconds(in: timeFrame[indice]), on: true))
                }
                for setting in notificationSettings {
                    setNotificationInUserDefaults(setting: setting)
                }
            } label: {
                HStack{
                    Text("Save")
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct AlertMeView_Previews: PreviewProvider {
    static var previews: some View {
        BasicSettingView(title: "Heart Rate Notifications"){
            AlertMeView(stats: [HeartRate.shared])
        }
        .preferredColorScheme(.dark)
    }
}
