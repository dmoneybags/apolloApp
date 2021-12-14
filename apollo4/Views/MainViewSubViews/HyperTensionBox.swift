//
//  HyperTensionBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/5/21.
//

import SwiftUI

struct HyperTensionBox: View {
    var SystolicReading: Double
    var DiastolicReading: Double
    var body: some View {
        let label = getBPLabel(systolicReading:SystolicReading, diastolicReading: DiastolicReading).0
        HStack{
            VStack{
                HStack{
                    TickMarkReader(length: 180, width: 30, stat: "SystolicPressure", reading: SystolicReading)
                        .padding(.leading, 80)
                    Spacer()
                    Divider()
                        .padding(.trailing, 50)
                    Spacer()
                    TickMarkReader(length: 180, width: 30, stat: "DiastolicPressure", reading: DiastolicReading)
                        .padding(.trailing
                        , 30)
                        
                }
                .frame(width: 300, height: 200, alignment: .center)
                Divider()
                HStack{
                    Text(label)
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.horizontal
                        )
                    Spacer()
                }
                Text(HypertensionStruct.descriptionDict[label]!)
                    .padding()
            }
        }
        .frame(width: 300)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)

    }
}

struct HyperTensionBox_Previews: PreviewProvider {
    static var previews: some View {
        HyperTensionBox(SystolicReading: 170, DiastolicReading: 80).preferredColorScheme(.dark)
    }
}
