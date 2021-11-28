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
    @State var SPdailyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var SPmonthlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var DPdailyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    @State var DPmonthlyData: [(Double, Date)]? = [(150, Date()), (117, Date()), (117, Date()), (118, Date()), (119, Date())]
    var body: some View {
        let graphData = [SPdailyData!.map{$0.0}, DPdailyData!.map{$0.0}]
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
                    CapsuleReader(range: getRange(data: DPdailyData!.map{$0.0}), min: DPdailyData!.map{$0.0}.min()!, reading: DPdailyData!.map{$0.0}.last!, height: 200)
                }
                HStack {
                    VStack {
                        Text("Systolic Pressure ")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.systemGray))
                        Text(String(SPdailyData!.map{$0.0}.last!))
                            .font(.title)
                            .padding(.top, 1.0)
                    }
                    .padding(.horizontal)
                    VStack {
                        Text("Diastolic Pressure")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.systemGray))
                        Text(String(DPdailyData!.map{$0.0}.last!))
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
