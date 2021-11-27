//
//  LiveGrapher.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/25/21.
//

import SwiftUI

struct LiveGrapher: View {
    @Binding var bpmData: [Double]
    @Binding var SPO2Data: [Double]
    @Binding var bpData: [[Double]]
    var body: some View {
        VStack{
            HStack{
                bpmMiniBox(title: "BPM", data: $bpmData.last!)
                SPO2MiniBox(title: "SPO2", data: $SPO2Data.last!)
            }
            bloodPressureMinibox(title: "Blood Pressure", bpData: $bpData)
                .padding()
        }
        .padding()
    }
}

struct LiveGrapher_Previews: PreviewProvider {
    static var previews: some View {
        LiveGrapher(bpmData: .constant([70.0]), SPO2Data: .constant([100.0]), bpData: .constant([[118], [7]]))
    }
}
