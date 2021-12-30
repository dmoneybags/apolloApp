//
//  FullScreenStatView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/20/21.
//

import SwiftUI
//Struct used to pass around arguments for stats fullscren views as JSON
struct statViewData {
    var name: String
    //ALL data not just some, as [(Double, Date)]
    //filtering will happen within the view
    var tupleData: [(Double, Date)]
    var dataRange: Double
    var dataMin: Double
    var gradient: Gradient
}
struct FullScreenStatView: View {
    var name: String
    //Next 3 values for graphing
    var tupleData: [(Double, Date)]
    var dataRange: Double
    var dataMin: Double
    var gradient: Gradient = Gradient(colors: [Color.yellow, Color.green])
    //Start on week
    @State private var timeFrame: Calendar.Component = .weekOfYear
    private var graphData: [(Double, Date)] {
        //Computd variable which returns the data for the timeframe
        return slimDataTuples(forData: tupleData, to: 100, within: timeFrame)
    }
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text(name)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .font(.title)
                    Spacer()
                }
                .padding()
                Divider()
                //Timeframe switcher
                HStack{
                    Text("Day")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green.opacity(timeFrame == .day ? 0.7 : 0.0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                timeFrame = .day
                            }
                        }
                    Spacer()
                    Text("Week")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green.opacity(timeFrame == .weekOfYear ? 0.7 : 0.0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                timeFrame = .weekOfYear
                            }
                        }
                    Spacer()
                    Text("Month")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green.opacity(timeFrame == .month ? 0.7 : 0.0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                timeFrame = .month
                            }
                        }
                    Spacer()
                    Text("Year")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green.opacity(timeFrame == .year ? 0.7 : 0.0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                timeFrame = .year
                            }
                        }
                }
                .padding(.horizontal)
                LineGraph(data: .constant(graphData.map{$0.0}), dataTime: .constant(graphData.map{$0.1}), dataMin: dataMin, dataRange: dataRange, height: 400, width: UIScreen.main.bounds.width, gradient: gradient, title: "  " + getTimeComponent(date: graphData.map{$0.1}.first!, timeFrame: .day) + " - " + getTimeComponent(date: graphData.map{$0.1}.last!, timeFrame: timeFrame == .day ? .hour : .day))
                    .padding(.top, 15)
            }
        }
    }
}
