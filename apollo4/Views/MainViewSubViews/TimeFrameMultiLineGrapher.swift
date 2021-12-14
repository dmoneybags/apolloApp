//
//  TimeFrameMultiLineGrapher.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/4/21.
//

import SwiftUI

struct TimeFrameMultiLineGrapher: View {
    var stat1DailyData: [(Double, Date)]
    var stat1MonthlyData: [(Double, Date)]
    var stat1YearlyData: [(Double, Date)]
    var stat2DailyData: [(Double, Date)]
    var stat2MonthlyData: [(Double, Date)]
    var stat2YearlyData: [(Double, Date)]
    var statNames: [String]
    @State private var timeFrame: Calendar.Component = .day
    @State private var data: [[(Double, Date)]]? = [[(0.0, Date()), (0.0, Date())], [(0.0, Date()), (0.0, Date())]]
    @State private var doubleData: [[Double]] = [[0.0, 0.0], [0.0, 0.0]]
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
                            data = getData()
                            doubleData = getDoubleData()
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
                            data = getData()
                            doubleData = getDoubleData()
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
                            data = getData()
                            doubleData = getDoubleData()
                        }
                    }
            }
            Divider()
            MultiLineGraph(data: $doubleData, dataWithLabels: $data, height: 350, width: 300, gradients: [Gradient(colors: [Color.red, Color.purple]), Gradient(colors: [Color.purple, Color.blue])], statNames: statNames)
        }
        .onAppear(){
            data = getData()
            doubleData = getDoubleData()
        }
    }
    func getData() -> [[(Double, Date)]]{
        switch timeFrame {
        case .day: return [stat1DailyData, stat2DailyData]
        case .month: return [stat1MonthlyData, stat2MonthlyData]
        case .year: return [stat1YearlyData, stat2YearlyData]
        default: return [stat1YearlyData, stat2YearlyData]
        }
    }
    func getDoubleData() -> [[Double]]{
        switch timeFrame {
        case .day: return [stat1DailyData.map{$0.0}, stat2DailyData.map{$0.0}]
        case .month: return [stat1MonthlyData.map{$0.0}, stat2MonthlyData.map{$0.0}]
        case .year: return [stat1YearlyData.map{$0.0}, stat2YearlyData.map{$0.0}]
        default: return [stat1YearlyData.map{$0.0}, stat2YearlyData.map{$0.0}]
        }
    }
}


