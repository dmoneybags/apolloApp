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
    @State var dailyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var monthlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var yearlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
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
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: dailyData!.map{$0.0})))), text: .constant(String(Int(averageData(data: dailyData!.map{$0.0})))))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This month")
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.center)
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: monthlyData!.map{$0.0})))), text: .constant(String(Int(averageData(data: monthlyData!.map{$0.0})))))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This year")
                        .foregroundColor(Color(UIColor.systemGray))
                    RingChart(progress: .constant(Double(getProgres(stat: stat, reading: averageData(data: yearlyData!.map{$0.0})))), text: .constant(String(Int(averageData(data: yearlyData!.map{$0.0})))))
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
