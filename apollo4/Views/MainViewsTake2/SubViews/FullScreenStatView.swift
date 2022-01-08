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
    //Actual technical name
    var statName: String?
    var tupleData: [(Double, Date)]
    var dataRange: Double
    var dataMin: Double
    var gradient: Gradient
}
struct FullScreenStatView: View {
    //Grabs the context of the presentation
    @Environment(\.presentationMode) var presentationMode
    //Stats passed in for inference
    @EnvironmentObject var statsWrapper: StatDataObjectListWrapper
    //Text at the top
    var name: String
    //Actual technical name
    var statName: String?
    //Next 3 values for graphing
    var tupleData: [(Double, Date)]
    var dataRange: Double
    var dataMin: Double
    var gradient: Gradient = Gradient(colors: [Color.yellow, Color.green])
    //Start on week
    @State private var timeFrame: Calendar.Component = .weekOfYear
    @State private var poolTimeFrame: Calendar.Component = .hour
    @State private var poolNum: Int = 1
    private var graphData: [(Double, Date)] {
        //Computd variable which returns the data for the timeframe
        return getTemporallyPooledData(forData: tupleData, within: timeFrame, poolTimeFrame: poolTimeFrame, num: poolNum)
    }
    //CHANGE CHANGE CHANGE CHANGE, taking name is temporary, and only to see if current implementation
    //works, eventually fullscreenstatview will take an optional argument of the statobject, and access
    //the string via stat object
    private var inferenceObject : aggregateInferenceObject{
        return aggregateInferenceObject(data: aggregateDataObject(stats: statsWrapper.stats, within: poolTimeFrame), forStat: statName, graphData: graphData)
    }
    var body: some View {
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
                            poolTimeFrame = .minute
                            poolNum = 15
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
                            poolTimeFrame = .hour
                            poolNum = 1
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
                            poolTimeFrame = .day
                            poolNum = 1
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
                            poolTimeFrame = .day
                            poolNum = 1
                        }
                    }
            }
            .padding(.horizontal)
            ScrollView{
                LineGraph(data: .constant(graphData.map{$0.0}), dataTime: .constant(graphData.map{$0.1}), dataMin: dataMin, dataRange: dataRange, height: 400, width: UIScreen.main.bounds.width - 60, gradient: gradient, title: "  " + getTimeComponent(date: graphData.map{$0.1}.first!, timeFrame: .day) + " - " + getTimeComponent(date: graphData.map{$0.1}.last!, timeFrame: timeFrame == .day ? .hour : .day), pooledData: true, aggregateInference: inferenceObject)
                    .padding(.top, 15)
                    .padding(.leading)
                    .padding(.bottom, 30)
                //Filter out odd numbers so our for each can hop row to row
                ForEach(inferenceObject.objectsToImplement.indices.filter{ $0 % 2 == 0 }, id: \.self){indice in
                    HStack{
                        inferenceObject.objectsToImplement[indice].box
                            .onTapGesture {
                                print("Sending notification to put \(indice) as object inFocus")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InferenceInFocus"), object: String(indice))
                            }
                        if indice + 1 < inferenceObject.objectsToImplement.count{
                            inferenceObject.objectsToImplement[indice + 1].box
                                .onTapGesture {
                                    print("Sending notification to put \(indice + 1) as object inFocus")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InferenceInFocus"), object: indice + 1)
                                }
                        } else {
                            //Empty view
                            VStack{
                                
                            }
                            .frame(width: UIScreen.main.bounds.size.width/2 - 30, height: 200)
                        }
                    }
                }
            }
            Spacer()
            Button("Exit", role: .destructive){
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
