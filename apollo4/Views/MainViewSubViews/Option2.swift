//
//  Option2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option2: View {
    @Binding var filename: URL
    @Binding var title: String
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
                    LineGraph(data: .constant(dailyData!.map{Double($0)}), height: 100, width: 160, heatGradient: true)
                }
                VStack{
                    Text("Average")
                        .foregroundColor(Color(UIColor.systemGray))
                    HStack {
                        Text(String(Int(averageData(data: dailyData!))))
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        Image(systemName: (dailyData!.last! > Int(averageData(data: dailyData!))) ? "arrow.up" : "arrow.down")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .center)
                            .foregroundColor(Color.blue)
                    }
                    .frame(width: 120, height: 100, alignment: .center)
                    .padding(.vertical)
                }
            }
            .frame(width: 300, height: 200, alignment: .center)
        }
        //.background(Color.yellow)
    }
}

struct Option2_Previews: PreviewProvider {
    static var previews: some View {
        Option2(filename: .constant(getDocumentsDirectory()), title: .constant("SPO2 Readings"))
    }
}
