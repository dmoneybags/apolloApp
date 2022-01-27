//
//  SendMyDataView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/24/22.
//

import SwiftUI
import UIKit
import NotificationBannerSwift

fileprivate let stats: [Stat] = [DiastolicPressure(), HeartRate(), SystolicPressure(), SPO2()]

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button(action: { withAnimation { configuration.$isOn.wrappedValue.toggle() }}){
                HStack{
                    configuration.label.foregroundColor(.primary)
                    Spacer()
                    if configuration.isOn {
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct SendMyDataView: View {
    @State private var sendStat = [Bool](repeating: false, count: stats.count)
    @State private var selectedTimeframe: Calendar.Component = .hour
    @State private var isNavigationBarHidden: Bool = true
    @State private var includeContactInfo: Bool = false
    @State private var includeTrendData: Bool = false
    @State private var sheetPresented: Bool = false
    private let errorNotification = NotificationBanner(title: "Error", subtitle: "Please select some stats (Tap on their names)", style: .danger)
    private var fileUrl: URL{
        return createDataFile(stats: statDataObjects, timeFrame: selectedTimeframe, includeContactInfo: includeContactInfo, includeTrend: includeTrendData)
    }
    private var statDataObjects: [StatDataObject] {
        return getStatDataObjectList(boolList: sendStat)
    }
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Stats")){
                    ForEach(0..<stats.count){i in
                        Toggle(isOn: $sendStat[i]){
                            Text(stats[i].displayName)
                            }.toggleStyle(CheckmarkToggleStyle())
                    }
                }
                Section(header: Text("Timeframe")){
                    Picker("Amount of time:", selection: $selectedTimeframe){
                        Text("Hour").tag(Calendar.Component.hour)
                        Text("Day").tag(Calendar.Component.day)
                        Text("Week").tag(Calendar.Component.weekOfYear)
                        Text("Month").tag(Calendar.Component.month)
                        Text("Year").tag(Calendar.Component.year)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.blue)
                }
                Section(header: Text("Additional Settings")){
                    Toggle(isOn: $includeContactInfo){
                        Text("Include my contact info")
                    }
                    .tint(.blue)
                    Toggle(isOn: $includeTrendData){
                        Text("Include trend information")
                    }
                    .tint(.blue)
                }
                Section(header: Text("")){
                    Button{
                        if areStatsPicked(boolList: sendStat){
                            sheetPresented = true
                        } else {
                            errorNotification.show()
                        }
                    } label: {
                        Text("Send my Data")
                            .foregroundColor(.blue)
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity)
            
        }
        .sheet(isPresented: $sheetPresented){
            ShareSheet(sharing: [fileUrl])
                .onAppear(){
                    assert(fileUrl != getDocumentsDirectory())
                }
        }
        .foregroundColor(Color(UIColor.systemGray))
    }
}

struct SendMyDataView_Previews: PreviewProvider {
    static var previews: some View {
        BasicSettingView(title: "Send Data"){
            SendMyDataView().preferredColorScheme(.dark)
        }
    }
}
func getStatDataObjectList(boolList: [Bool]) -> [StatDataObject]{
    var statDataObjectList: [StatDataObject] = []
    let statDataObjects = fetchStatDataObjects()
    for indice in boolList.indices{
        if boolList[indice]{
            statDataObjectList.append(statDataObjects[indice])
        }
    }
    return statDataObjectList
}
func areStatsPicked(boolList: [Bool]) -> Bool {
    for i in boolList{
        if i {
            return true
        }
    }
    return false
}
