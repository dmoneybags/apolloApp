//
//  MultilineFullScreenStatView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/9/22.
//

import SwiftUI

struct MultilineFullScreenStatView: View {
    @Environment(\.presentationMode) var presentationMode
    //Text at the top
    var name: String
    //Actual technical name
    var multiTupleData: [[(Double, Date)]]
    @State private var timeFrame: Calendar.Component = .weekOfYear
    @State private var poolTimeFrame: Calendar.Component = .hour
    @State private var poolNum: Int = 1
    private var graphData: ([[Double]], [[Date]]) {
        var doubles: [[Double]] = []
        var dates: [[Date]] = []
        for graphData in multiTupleData{
            let statData = getTemporallyPooledData(forData: graphData, within: timeFrame, poolTimeFrame: poolTimeFrame, num: poolNum)
            doubles.append(statData.map{$0.0})
            dates.append(statData.map{$0.1})
        }
        return (doubles, dates)
    }
    private var inferenceObject: aggregateInferenceObject {
        return aggregateInferenceObject(forStats: ["SystolicPressure", "DiastolicPressure"], graphData: reconstituteParralellTimeStampedData(doubles: graphData.0, dates: graphData.1))
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
                            //use first set in list to set pool timeFrame
                            setPoolTimeFrame(data: multiTupleData[0], maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
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
                            setPoolTimeFrame(data: multiTupleData[0], maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
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
                            setPoolTimeFrame(data: multiTupleData[0], maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
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
                            setPoolTimeFrame(data: multiTupleData[0], maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
                        }
                    }
            }
            .padding(.horizontal)
            ScrollViewReader { proxy in
                ScrollView{
                    LazyVStack{
                        MultiLineGraph(data: .constant(graphData.0), dataWithLabels: .constant(graphData.1), height: 400, width: UIScreen.main.bounds.width - 60, gradients: [Gradient(colors: [Color.pink, Color.purple]), Gradient(colors: [Color.purple, Color.blue])], statNames: ["Systolic Pressure", "Diastolic Pressure"], title: getTimeComponent(date: graphData.1[0].first!, timeFrame: .day) + "-" + getTimeComponent(date: graphData.1[0].last!, timeFrame: .day), pooledData: true, aggregateInference: inferenceObject)
                            .id(0)
                            .padding()
                            .padding(.bottom, 15)
                        //Filter out odd numbers so our for each can hop row to row
                        ForEach(inferenceObject.multiLineObjectsToImplement.indices.filter{ $0 % 2 == 0 }, id: \.self){indice in
                            HStack{
                                inferenceObject.multiLineObjectsToImplement[indice].box
                                    .onTapGesture {
                                        print("Sending notification to put \(indice) as object inFocus")
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InferenceInFocus"), object: String(indice))
                                        withAnimation(){
                                            proxy.scrollTo(0, anchor: .bottom)
                                        }
                                    }
                                if indice + 1 < inferenceObject.multiLineObjectsToImplement.count{
                                    inferenceObject.multiLineObjectsToImplement[indice + 1].box
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
            setPoolTimeFrame(data: multiTupleData[0], maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
        }
    }
}

func reconstituteParralellTimeStampedData(doubles: [[Double]], dates: [[Date]]) -> [[(Double, Date)]]{
    var tupleList: [[(Double, Date)]] = []
    var iterator1 = 0
    var iterator2 = 0
    for listVal in doubles {
        var singularTupleList: [(Double, Date)] = []
        for dataVal in listVal {
            singularTupleList.append((dataVal, dates[iterator1][iterator2]))
            iterator2 += 1
        }
        tupleList.append(singularTupleList)
        iterator2 = 0
        iterator1 += 1
    }
    print("reconstituted data, generated \(tupleList)")
    return tupleList
}
