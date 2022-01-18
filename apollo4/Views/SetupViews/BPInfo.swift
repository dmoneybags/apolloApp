//
//  BPInfo.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/17/22.
//

import SwiftUI

struct BPInfo: View {
    @ObservedObject var userData: UserData
    @State var systolicPressure: Int = 30
    @State var diastolicPressure: Int = 30
    var body: some View {
        ScrollView{
            Text("An initial blood pressure reading is needed to calibrate the ring. This can be a reading from a manual or electric pump, or could also be from a doctors appointment within the past month.")
                .padding()
            Button("I don't have a reading"){
                print("no reading")
            }
            Divider()
            HStack{
                Text("Systolic Pressure:")
                    .font(.title2)
                    .padding()
                Spacer()
                Picker(selection: $systolicPressure, label: Text("Systolic Pressure")) {
                    ForEach(80 ..< 250) {
                        Text("\($0) mmHG")
                    }
                }
            }
            HStack{
                Text("Diastolic Pressure:")
                    .font(.title2)
                    .padding()
                Spacer()
                Picker(selection: $diastolicPressure, label: Text("Diastolic Pressure")) {
                    ForEach(40 ..< 250) {
                        Text("\($0) mmHG")
                    }
                }
            }
        }
    }
}
