//
//  SPO2DetailView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/28/21.
//

import SwiftUI

struct SPO2DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let SPO2Path: URL = getDocumentsDirectory().appendingPathComponent("SPO2")
    let SPO2Pub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "SPO2"))
    @State var mostRecentReading: Double = getData(filename: getDocumentsDirectory().appendingPathComponent("SPO2"), timeFrame: .day).map{$0.0}.last!
    var body: some View {
        VStack{
            ScrollView{
                Text("Oxygen Saturation")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("Oxygen Saturation is a measure of the bodys disolved oxygen within the blood stream. Various factors such as energy and respiration affect saturation.")
                    .padding(.horizontal)
                    .font(.footnote)
                Option3(filename: SPO2Path, title: "", dailyData: getData(filename: SPO2Path, timeFrame: .day), monthlyData: getData(filename: SPO2Path, timeFrame: .month), yearlyData: getData(filename: SPO2Path, timeFrame: .year))
                HStack{
                    SPO2MiniBox(title: "SPO2", data: $mostRecentReading)
                    bpmReadingsBox(stat: "SPO2")
                }
                Divider()
                BarChartView(data: ChartData(values: convertDateValuesToString(data: filterData(data: getData(filename: SPO2Path, timeFrame: .year), timeFrame: .hour, num: 1))), title: "Monthly Readings", style: Styles.barChartStyleNeonBlueDark, form: CGSize(width: 340, height: 350), dropShadow: false)
            }
            backBtn()
        }
        .onReceive(SPO2Pub){reading in
            let value = (reading.object as! NSString).doubleValue
            mostRecentReading = value
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 0.3)
        .padding(.bottom, 0.3)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct SPO2DetailView_Previews: PreviewProvider {
    static var previews: some View {
        SPO2DetailView()
    }
}
