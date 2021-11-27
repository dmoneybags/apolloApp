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
    @State var dailyData: [Int]? = [150, 117, 117, 118, 119]
    @State var monthlyData: [Int]? = [119, 119, 110, 110, 112]
    @State var yearlyData: [Int]? = [111, 113]
    var body: some View {
        VStack {
            Text(title)
            Divider()
                .padding(.horizontal)
            HStack {
                VStack{
                    Text("Current")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text(String(dailyData!.last!))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Image(systemName: (dailyData!.last! > Int(averageData(data: dailyData!))) ? "arrow.up" : "arrow.down")
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
                        Text(String(Int(getMax(data: dailyData!))))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        VStack{
                            Text("4")
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text("PM")
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
                        Text(String(Int(getMin(data: dailyData!))))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        VStack{
                            Text("2")
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text("AM")
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
