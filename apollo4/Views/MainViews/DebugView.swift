//
//  DebugView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/12/21.
//

import SwiftUI

struct DebugView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    var body: some View {
        VStack {
            if stats.isEmpty {
                Text("No stats!")
                Button("add stats"){
                    let SPO2DataObject = StatDataObject(inputName: "SPO2", context: moc, empty: false)
                    let HeartRateDataObject = StatDataObject(inputName: "HeartRate", context: moc, empty: false)
                    let SystolicPressureDataObject = StatDataObject(inputName: "SystolicPressure", context: moc, empty: false)
                    let DiastolicPressureDataObject = StatDataObject(inputName: "DiastolicPressure", context: moc, empty: false)
                    try? moc.save()
                }
            } else {
                ForEach(Array(stats)){value in
                    Text(value.name ?? "no name")
                        .onTapGesture {
                            print(value.data)
                            print(value.dates)
                        }
                }
            }
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
