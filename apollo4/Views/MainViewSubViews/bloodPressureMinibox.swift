//
//  bloodPressureMinibox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/26/21.
//

import SwiftUI

struct bloodPressureMinibox: View {
    @Environment(\.colorScheme) var colorScheme
    @State var title: String = "BPM"
    //SYSTOLIC FIRST DIASTOLIC SECOND
    @Binding var bpData: [[Double]]
    var body: some View {
        VStack{
            Text("Blood Pressure")
                .font(.title2)
                .fontWeight(.bold)
            Divider()
            HStack {
                MultiLineGraph(data: $bpData, height: 100, width: 250, gradients: [Gradient(colors: [Color.pink, Color.purple]), Gradient(colors: [Color.blue, Color.purple])])
                    .padding(.trailing, -20.0)
                VStack{
                    Text(String(Int(bpData[0].last!)))
                        .font(.title)
                        .fontWeight(.bold)
                    Divider()
                    Text(String(Int(bpData[1].last!)))
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
        .frame(width: 320, height: 210, alignment: .center)
        .background(colorScheme != .dark ? Color.white: Color.black)
        .cornerRadius(15)
    }
}

struct bloodPressureMinibox_Previews: PreviewProvider {
    static var previews: some View {
        bloodPressureMinibox(bpData: .constant([[118.0,116.0,117.0,119.0], [70.0,69.0,68.0,57.0,67.0]]))
    }
}
