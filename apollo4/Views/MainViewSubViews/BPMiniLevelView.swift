//
//  BPMiniLevelView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/20/21.
//

import SwiftUI

struct BPMiniLevelView: View {
    @Binding var sysData: [Double]
    @Binding var diaData: [Double]
    var body: some View {
        VStack{
            HStack{
                Text("Todays Level")
                    .font(.title2)
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            HStack{
                TickMarkReader(length: 250, width: 30, stat: "SystolicPressure", reading: averageData(data: sysData))
                    .padding(.leading, 70)
                    .padding(.trailing, 70)
                TickMarkReader(length: 250, width: 30, stat: "DiastolicPressure", reading: averageData(data: diaData))
                Divider()
                VStack{
                    Text(SystolicPressure().getLabel(reading: averageData(data: sysData)))
                        .font(.title)
                        .padding(.top)
                    Divider()
                    Spacer()
                    Text(HypertensionStruct.descriptionDict[SystolicPressure().getLabel(reading: averageData(data: sysData))]!)
                        .font(.callout)
                        .padding(.bottom, 15)
                        .padding(.horizontal)
                    Divider()
                    Button("Read More...", action: pass)
                }
            }
        }
    }
    private func pass(){
        print("")
    }
}
