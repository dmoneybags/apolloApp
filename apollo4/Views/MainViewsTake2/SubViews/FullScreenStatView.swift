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
    var tupleData: [(Double, Date)] = []
    var dataRange: Double = 0
    var dataMin: Double = 0
    var gradient: Gradient = Gradient(colors: [.blue, .purple])
    var gradients: [Gradient]? = nil
    var multiTupleData: [[(Double, Date)]]? = nil
}
struct FullScreenStatView: View {
    //Grabs the context of the presentation
    @Environment(\.presentationMode) var presentationMode
    //Text at the top
    var name: String
    //Actual technical name
    var statName: String?
    //Next 3 values for graphing
    var tupleData: [(Double, Date)]
    var dataRange: Double
    var dataMin: Double
    var gradient: Gradient = Gradient(colors: [Color.yellow, Color.green])
    var showTitle: Bool = true
    //Start on week
    @State private var timeFrame: Calendar.Component = .weekOfYear
    @State private var poolTimeFrame: Calendar.Component = .day
    @State private var poolNum: Int = 1
    private var graphData: [(Double, Date)] {
        //Computd variable which returns the data for the timeframe
        return getTemporallyPooledData(forData: tupleData, within: timeFrame, poolTimeFrame: poolTimeFrame, num: poolNum)
    }
    //CHANGE CHANGE CHANGE CHANGE, taking name is temporary, and only to see if current implementation
    //works, eventually fullscreenstatview will take an optional argument of the statobject, and access
    //the string via stat object
    private var inferenceObject : aggregateInferenceObject{
        return aggregateInferenceObject(data: aggregateDataObject(stats: StatDataObjectListWrapper.stats, within: timeFrame), forStat: statName, graphData: graphData)
    }
    var body: some View {
        VStack{
            if showTitle{
                HStack{
                    Text(name)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .font(.title)
                    Spacer()
                }
                .padding()
                Divider()
            }
            //Timeframe switcher
            HStack{
                Text("Day")
                    .fontWeight(.bold)
                    .padding(10)
                    .background(Color.green.opacity(timeFrame == .day ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(){
                            timeFrame = .day
                            poolTimeFrame = .minute
                            poolNum = 15
                            setPoolTimeFrame(data: tupleData, maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
                        }
                    }
                Spacer()
                Text("Week")
                    .fontWeight(.bold)
                    .padding(10)
                    .background(Color.green.opacity(timeFrame == .weekOfYear ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(){
                            timeFrame = .weekOfYear
                            poolTimeFrame = .hour
                            poolNum = 1
                            setPoolTimeFrame(data: tupleData, maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
                        }
                    }
                Spacer()
                Text("Month")
                    .fontWeight(.bold)
                    .padding(10)
                    .background(Color.green.opacity(timeFrame == .month ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(){
                            timeFrame = .month
                            poolTimeFrame = .day
                            poolNum = 1
                            setPoolTimeFrame(data: tupleData, maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
                        }
                    }
                Spacer()
                Text("Year")
                    .fontWeight(.bold)
                    .padding(10)
                    .background(Color.green.opacity(timeFrame == .year ? 0.7 : 0.0))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(){
                            timeFrame = .year
                            poolTimeFrame = .day
                            poolNum = 1
                            setPoolTimeFrame(data: tupleData, maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
                        }
                    }
            }
            .padding(.horizontal)
            ScrollViewReader { proxy in
                ScrollView{
                    VStack{
                        LineGraph(data: .constant(graphData.map{$0.0}), dataTime: .constant(graphData.map{$0.1}), dataMin: dataMin, dataRange: dataRange, height: 400, width: UIScreen.main.bounds.width - 60, gradient: gradient, title: graphData.isEmpty ? "No Data" : "  " + getTimeComponent(date: graphData.map{$0.1}.first!, timeFrame: .day) + " - " + getTimeComponent(date: graphData.map{$0.1}.last!, timeFrame: timeFrame == .day ? .hour : .day), pooledData: true, aggregateInference: inferenceObject)
                            .padding(.top, 15)
                            .padding(.leading)
                            .padding(.bottom, 30)
                            .id(0)
                        //Filter out odd numbers so our for each can hop row to row
                        ForEach(inferenceObject.objectsToImplement.indices.filter{ $0 % 2 == 0 }, id: \.self){indice in
                            HStack{
                                inferenceObject.objectsToImplement[indice].box
                                    .onTapGesture {
                                        print("Sending notification to put \(indice) as object inFocus")
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InferenceInFocus"), object: String(indice))
                                        withAnimation(){
                                            proxy.scrollTo(0, anchor: .bottom)
                                        }
                                    }
                                if indice + 1 < inferenceObject.objectsToImplement.count{
                                    inferenceObject.objectsToImplement[indice + 1].box
                                        .onTapGesture {
                                            print("Sending notification to put \(indice + 1) as object inFocus")
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InferenceInFocus"), object: String(indice + 1))
                                            withAnimation(.easeIn(duration: 1.0)){
                                                proxy.scrollTo(0, anchor: .bottom)
                                            }
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
                }
            }
            Spacer()
            Button("Exit", role: .destructive){
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear{
            setPoolTimeFrame(data: tupleData, maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
        }
    }
}
