//
//  Option3.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option3: View {
    @Binding var filename: URL
    @Binding var title: String
    @State var dailyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var monthlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var yearlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    var body: some View {
        let maxVal: Double = getMax(data: dailyData!.map{$0.0})
        let minVal: Double = getMin(data: dailyData!.map{$0.0})
        let minIndex: Int = dailyData!.map{$0.0}.firstIndex(of: minVal)!
        let maxIndex: Int = dailyData!.map{$0.0}.firstIndex(of: minVal)!
        let minTime: Date = dailyData!.map{$0.1}[minIndex]
        let maxTime: Date = dailyData!.map{$0.1}[maxIndex]
        let minTimeStr: String = getTimeComponent(date: minTime, timeFrame: .hour)
        let maxTimeStr: String = getTimeComponent(date: maxTime, timeFrame: .hour)
        VStack {
            Text(title)
            Divider()
                .padding(.horizontal)
            HStack {
                VStack{
                    Text("Current")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text(String(dailyData!.map{$0.0}.last!))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Image(systemName: (dailyData!.map{$0.0}.last! > averageData(data: dailyData!.map{$0.0})) ? "arrow.up" : "arrow.down")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .center)
                            .foregroundColor(Color.red)
                    }
                    .frame(width: 100, height: 60, alignment: .center)
                    .padding(.vertical)
                }
                VStack {
                    Text("High")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text(String(Int(maxVal)))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        VStack{
                            Text(maxTimeStr.split(separator: " ")[0])
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text(maxTimeStr.split(separator: " ")[1])
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: 100, height: 60, alignment: .center)
                    .padding(.vertical)
                }
                VStack {
                    Text("Low")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text(String(Int(minVal)))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        VStack{
                            Text(minTimeStr.split(separator: " ")[0])
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text(minTimeStr.split(separator: " ")[1])
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: 100, height: 60, alignment: .center)
                    .padding(.vertical)
                }
            }
            .frame(width: 300, height: 180, alignment: .center)
        }
    }
}

struct Option3_Previews: PreviewProvider {
    static var previews: some View {
        Option3(filename: .constant(getDocumentsDirectory()), title: .constant("SPO2 Readings"))
    }
}
