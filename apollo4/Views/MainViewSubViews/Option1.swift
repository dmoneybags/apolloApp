//
//  Option1.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option1: View {
    @Binding var filename: URL
    @Binding var title: String
    @State var stat: String = "SPO2"
    @State var dailyData: [Int]? = [150, 117, 117, 118, 119]
    @State var monthlyData: [Int]? = [119, 119, 110, 110, 112]
    @State var yearlyData: [Int]? = [111, 113]
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .font(.title2)
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            HStack {
                VStack {
                    Text("Today")
                        .foregroundColor(Color(UIColor.systemGray))
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: dailyData!)))), text: .constant(String(Int(averageData(data: dailyData!)))))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This month")
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.center)
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: monthlyData!)))), text: .constant(String(Int(averageData(data: monthlyData!)))))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This year")
                        .foregroundColor(Color(UIColor.systemGray))
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: yearlyData!)))), text: .constant(String(Int(averageData(data: yearlyData!)))))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
            }
            .frame(width: 300, height: 120, alignment: .center)
        }
        //.background(Color.green)
    }
}

struct Option1_Previews: PreviewProvider {
    static var previews: some View {
        Option1(filename: .constant(getDocumentsDirectory().appendingPathComponent("SPO2")), title: .constant("BPM Averages"))
    }
}
