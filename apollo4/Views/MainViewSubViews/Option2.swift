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
                    LineGraph(data: .constant(dailyData!.map{$0.0}), height: 100, width: 160, heatGradient: true)
                }
                VStack{
                    Text("Average")
                        .foregroundColor(Color(UIColor.systemGray))
                    HStack {
                        Text(String(Int(averageData(data: dailyData!.map{$0.0}))))
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        Image(systemName: (dailyData!.map{$0.0}.last! > averageData(data: dailyData!.map{$0.0})) ? "arrow.up" : "arrow.down")
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
