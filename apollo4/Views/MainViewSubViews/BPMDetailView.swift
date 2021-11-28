//
//  BPMDetailView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/27/21.
//

import SwiftUI

struct BPMDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let bpmPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "HeartRate"))
    @State var mostRecentReading: Double = getData(filename: getDocumentsDirectory().appendingPathComponent("HeartRate"), timeFrame: .day).map{$0.0}.last!
    var body: some View {
        VStack{
            ScrollView{
                Text("Heart Rate")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Text("The heart rate can vary according to the body's physical needs, including genetics, illness, and energy")
                    .padding(.horizontal)
                    .font(.footnote)
                HStack{
                    bpmMiniBox(data: $mostRecentReading)
                        .padding()
                    bpmReadingsBox(stat: "HeartRate")
                        .padding()
                }
                timeFrameGrapher()
                backBtn()
            }
        }
        .onReceive(bpmPub){reading in
            let value = (reading.object as! NSString).doubleValue
            mostRecentReading = value
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 0.3)
        .padding(.bottom, 0.3)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct BPMDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BPMDetailView().preferredColorScheme(.dark
        )
    }
}
