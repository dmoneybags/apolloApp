//
//  timeFrameGrapher.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/28/21.
//

import SwiftUI

struct timeFrameGrapher: View {
    @State var stat: String = "HeartRate"
    @State var data: [(Double, Date)]? = getData(filename: getDocumentsDirectory().appendingPathComponent("HeartRate"), timeFrame: .day)
    @State var timeFrame: Calendar.Component = .day
    @State var gradient: Gradient = Gradient(colors: [Color.orange, Color.pink])
    var body: some View {
        VStack{
            Divider()
            HStack{
                Text("Day")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.green.opacity(timeFrame == .day ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        timeFrame = .day
                        withAnimation(){
                            data = getData(filename: getDocumentsDirectory().appendingPathComponent(stat), timeFrame: .day)
                        }
                    }
                Spacer()
                Text("Month")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.green.opacity(timeFrame == .month ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        timeFrame = .month
                        withAnimation(){
                            data = getData(filename: getDocumentsDirectory().appendingPathComponent(stat), timeFrame: .month)
                        }
                    }
                Spacer()
                Text("Year")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.green.opacity(timeFrame == .year ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        timeFrame = .year
                        withAnimation(){
                            data = filterData(data: getData(filename: getDocumentsDirectory().appendingPathComponent(stat), timeFrame: .year), timeFrame: .hour, num: 1) 
                        }
                    }
            }
            Divider()
            LineGraph(data: .constant(data!.map{$0.0}), dataTime: $data, height: 350, width: 300, gradient: gradient)
        }
    }
}

struct timeFrameGrapher_Previews: PreviewProvider {
    static var previews: some View {
        timeFrameGrapher().preferredColorScheme(.dark)
    }
}
