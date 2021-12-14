//
//  bpmReadingsBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/27/21.
//
/// Basically having a drag gesture fucks scrollview up, for now just show readings,
/// fix later

import SwiftUI
struct hashableReading:Hashable {
    let data:Double
    let date:Date
}
struct bpmReadingsBox: View {
    @State var selector = 1
    var allowZero = false
    var stat: String
    var body: some View {
        let HeartRatePath = getDocumentsDirectory().appendingPathComponent(stat)
        let readings = filterData(data: getData(filename: HeartRatePath, timeFrame: .day), timeFrame: .minute, num: 1)
        VStack{
            HStack {
                ForEach(0...1, id: \.self){index in
                    Circle()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(selector == index ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
                }
            }
            if selector == 0{
                Text("Medium")
                Divider()
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                    .padding()
            } else {
                ScrollView{
                    if readings[0].0 != 0 || allowZero {
                        ForEach(readings.map{hashableReading(data: $0.0, date: $0.1)}, id: \.self){reading in
                            HStack {
                                Text(String(getTimeComponent(date: reading.date, timeFrame: .hour)))
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .padding()
                                Spacer()
                                Text(String(Int(reading.data)))
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .padding()
                            }
                            Divider()
                        }
                    } else {
                        Text("No Data")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
            }
        }
        .frame(width: 150, height: 210, alignment: .center)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        
    }
}

struct bpmReadingsBox_Previews: PreviewProvider {
    static var previews: some View {
        bpmReadingsBox(stat: "SPO2")
    }
}
