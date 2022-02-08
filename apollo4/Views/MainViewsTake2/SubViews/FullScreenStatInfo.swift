//
//  FullScreenStatInfo.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/12/22.
//

import SwiftUI
//DO NOT USE FOR HR ONLY RESTING HR
//FIX: Create function to get label from 2 separate bp labels

//Full Screen Stat info, will have a title, most likely statname + "HealthInfo",
//a subtitle, like the range for the data or something. Which initializer is used will decide
//whether or not the view is rendered with a dateSwitcher or not (dateSwitcher code is copy paste)
//from full screen statview just so we dont have to initialize a StateObject property (the latter probably
// the better way)
struct FullScreenStatInfo: View {
    //Grabs the context of the presentation
    @Environment(\.presentationMode) var presentationMode
    private var statDataObject: [StatDataObject]?
    //Only a single set of data
    private var tupleData: [[(Double, Date)]] = []
    private var title: String
    private var subtitle: String
    private var readings: [Double]?
    private var statInfo: [Stat] = []
    private var multipleData: Bool
    private var colors: [Color]
    @State private var timeFrame: Calendar.Component = .weekOfYear
    @State private var showInfo: Bool = false
    private var filteredData: [[(Double, Date)]]{
        var data: [[(Double, Date)]] = []
        for tuples in tupleData {
            data.append(filterDataTuples(forData: tuples, in: timeFrame))
        }
        return data
    }
    init(statData: [StatDataObject], topText: String, subText: String, colors: [Color]){
        self.statDataObject = statData
        self.title = topText
        self.subtitle = subText
        for dataObject in self.statDataObject! {
            statInfo.append(dataObject.statInfo!)
        }
        for dataObject in self.statDataObject! {
            tupleData.append(dataObject.generateTupleData())
        }
        self.multipleData = true
        self.colors = colors
    }
    init(tupleData: [[(Double, Date)]], topText: String, subText: String, stats: [Stat], colors: [Color]){
        self.tupleData = tupleData
        self.title = topText
        self.subtitle = subText
        self.statInfo = stats
        self.multipleData = true
        self.colors = colors
    }
    init(readings: [Double], topText: String, subText: String, stats: [Stat], colors: [Color]){
        self.title = topText
        self.subtitle = subText
        self.statInfo = stats
        self.readings = readings
        self.multipleData = false
        self.colors = colors
    }
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .font(.title)
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.bottom, 5)
                    .offset(x: -10, y: 0.0)
                    .foregroundColor(Color(UIColor.systemGray))
                    .onTapGesture {
                        showInfo = true
                    }
                    .fullScreenCover(isPresented: $showInfo){
                        WhatIsStatName(stats: statInfo)
                    }
                Spacer()
            }
            .padding()
            Text(subtitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            Divider()
            //Timeframe switcher
            if multipleData {
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
            }
            ScrollView{
                ZStack{
                    ForEach(colors.indices, id: \.self){indice in
                        RingChart(progress: .constant(getProgress(stat: statInfo[indice].name, reading: multipleData ? averageData(data: filteredData[indice].map{$0.0}) : readings![indice])), text: .constant(""), color: colors[indice])
                            .padding(.all, CGFloat(indice) * 25)
                    }
                    VStack{
                        ForEach(colors.indices, id: \.self){indice in
                            if indice != 0 {
                                Divider()
                                    .padding(.horizontal, 40)
                            }
                            Text(String(format: "%.01f", (multipleData ? averageData(data: filteredData[indice].map{$0.0}):readings![indice])))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(colors[indice])
                                .scaleEffect(1.5)
                            Text(statInfo[indice].measurement)
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.width - 30)
                .padding()
                Divider()
                VStack{
                    //Use special blood prssure dict
                    if title == "Blood Pressure" {
                        Text(getBPLabel(systolicReading: multipleData ? averageData(data: filteredData[0].map{$0.0}) : readings![0], diastolicReading: multipleData ? averageData(data: filteredData[1].map{$0.0}) : readings![1]).0)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(getColor(stat: statInfo[0].name, progress: getProgress(stat: statInfo[0].name, reading: multipleData ? averageData(data: filteredData[0].map{$0.0}) : readings![0])))
                            .padding(.horizontal)
                    } else {
                        Text(statInfo[0].getLabel(reading: multipleData ? averageData(data: filteredData[0].map{$0.0}) : readings![0]))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(getColor(stat: statInfo[0].name, progress: getProgress(stat: statInfo[0].name, reading: multipleData ? averageData(data: filteredData[0].map{$0.0}) : readings![0])))
                            .padding(.horizontal)
                    }
                    Divider()
                        .padding(.horizontal, 50)
                    Text("\t Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .foregroundColor(Color(UIColor.systemGray2))
                        .padding(.horizontal)
                    Spacer()
                }
            }
            Spacer()
            Button("Exit", role: .destructive){
                presentationMode.wrappedValue.dismiss()
            }
        }
        .background(LinearGradient(colors: [colors[0].opacity(0.4), .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
    }
    private func getAggregateProgress() -> Double {
        //YOU MUST PASS AN EQUAL NUM OF STATS AS POINTS
        var average = 0.0
        var count = 0.0
        for i in 0..<statInfo.count{
            movingAverage(previousAverage: &average, count: &count, newValue: getProgress(stat: statInfo[i].name, reading: multipleData ? averageData(data: filteredData[i].map{$0.0}) : readings![i]))
        }
        return average
    }
}

