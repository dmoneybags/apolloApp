//
//  BPOption1.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/23/21.
//

import SwiftUI

struct BPOption1: View {
    @State var SPfileName: URL
    @State var DPfileName: URL
    @State var title: String
    @State var SPdailyData: [Int]? = [118, 119, 118, 116, 116, 114, 112]
    @State var SPmonthlyData: [Int]? =  [118,117,116,117,116,116]
    @State var DPdailyData: [Int]? = [70,71,73,72,73,71,70,71]
    @State var DPmonthlyData: [Int]? = [76, 74, 73, 72,73, 71, 70, 82, 85]
    var body: some View {
        let graphData = [SPdailyData!.map{Double($0)}, DPdailyData!.map{Double($0)}]
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .font(.title2)
                Spacer()
            }
            Divider()
                .foregroundColor(Color.white)
            VStack {
                HStack {
                    VStack {
                        Text("Today")
                            .foregroundColor(Color(UIColor.systemGray))
                        MultiLineGraph(data: .constant(graphData), height: 150, width: 180, gradients: [Gradient(colors: [Color.red, Color.purple]), Gradient(colors: [Color.pink, Color.blue])], backgroundColor: nil)
                    }
                    CapsuleReader(range: Double(getRange(data: DPmonthlyData!)), min: Double(DPmonthlyData!.min()!), reading: Double(DPdailyData!.last!), height: 200)
                }
                HStack {
                    VStack {
                        Text("Systolic Pressure ")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.systemGray))
                        Text(String(SPdailyData!.last!))
                            .font(.title)
                            .padding(.top, 1.0)
                    }
                    .padding(.horizontal)
                    VStack {
                        Text("Diastolic Pressure")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.systemGray))
                        Text(String(DPdailyData!.last!))
                            .font(.title)
                            .padding(.top, 1.0)
                    }
                    .padding(.horizontal)
                }
            }
            .frame(width: 300, height: 400, alignment: .center)
        }
    }
}

struct BPOption1_Previews: PreviewProvider {
    static var previews: some View {
        BPOption1(SPfileName: getDocumentsDirectory(), DPfileName: getDocumentsDirectory(),title: "Blood Pressure")
    }
}
