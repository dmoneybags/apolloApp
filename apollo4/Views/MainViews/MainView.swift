//
//  MainView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/18/21.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    let SPO2Path = getDocumentsDirectory().appendingPathComponent("SPO2")
    let HeartRatePath = getDocumentsDirectory().appendingPathComponent("HeartRate")
    let SPPath = getDocumentsDirectory().appendingPathComponent("SystolicPressure")
    let DPPath = getDocumentsDirectory().appendingPathComponent("DiastolicPressure")
    var body: some View {
        VStack {
            ScrollView {
                Option1(filename: .constant(SPO2Path), title: .constant("SPO2"), stat: "SPO2", dailyData: getData(filename: SPO2Path, timeFrame: .day), monthlyData: getData(filename: SPO2Path, timeFrame: .month), yearlyData: getData(filename: SPO2Path, timeFrame: .year))
                Option2(filename: .constant(HeartRatePath), title: .constant("BPM"), dailyData: getData(filename: HeartRatePath, timeFrame: .day), monthlyData: getData(filename: HeartRatePath, timeFrame: .month), yearlyData: getData(filename: HeartRatePath, timeFrame: .year))
                    .padding(.bottom)
                BPOption1(SPfileName: SPPath, DPfileName: DPPath, title: "Blood Pressure", SPdailyData: getData(filename: SPPath, timeFrame: .day), SPmonthlyData: getData(filename: SPPath, timeFrame: .month), DPdailyData: getData(filename: DPPath, timeFrame: .day), DPmonthlyData: getData(filename: DPPath, timeFrame: .year))
                
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 0.3)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark)
    }
}
