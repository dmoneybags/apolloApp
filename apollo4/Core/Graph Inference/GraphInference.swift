//
//  GraphInference.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/6/22.
//

import Foundation
import SwiftUI

//Object to hold multiple sets of data
struct aggregateDataObject {
    var statData : [String: [(Double, Date)]]
    //timeFrame and offset allow us to filter our data appropiately
    var timeFrame : Calendar.Component
    var offset : Int = 0
    init(stats: [StatDataObject], within givenTimeFrame: Calendar.Component){
        timeFrame = givenTimeFrame
        statData = [:]
        for stat in stats {
            print("Adding \(stat.name!) to statData")
            statData[stat.name!] = filterDataTuples(forData: stat.generateTupleData(), in: timeFrame, withOffset: offset)
        }
    }
}
protocol InferenceObjectBase: AnyObject {
    //Empty initializer will always be used, it is up to the aggregate Inference Object to call the in the instance with real data
    init()
    var title: String {get}
    var subTitle: String {get}
    //Box is what we will show as a box on the main graph view
    var box: AnyView {get}
    var data: [Double] {get}
    //What will appear on the graph
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView 
    //Takes in an aggregate Data object and evaluates whether or not the inference is valid
    //EX: a relaxation inference object evaluates when a users blood pressure and heart rate drop below a certain level and the time is between
    //11 am and 8pm, if no spans of data within the aggregate data object matches this, the function will return false
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?)
}

//Everytime a new inference is created it must be added to this list of it will not be checked
fileprivate let objectsToCheck: [InferenceObjectBase] = [minimum()]
//Will error if passed an improper main stat
class aggregateInferenceObject: ObservableObject{
    //mainStat is the main stat we are looking at. For example, if we want to make inferences based mainly on SPO2, to easily get values like min, max, and trend
    //we need a singular main stat to look for these values.
    var mainStat: String? = nil
    var objectsToImplement: [InferenceObjectBase] = []
    var timeFrame : Calendar.Component
    //Object in focus is an integer representing the inference which the user is focusing on
    @Published var objectInFocus : Int
    init(data: aggregateDataObject, forStat stat: String? = nil, graphData: [(Double, Date)]){
        objectInFocus = -1
        mainStat = stat
        timeFrame = data.timeFrame
        for inference in objectsToCheck{
            if(inference.isValid(aggregateData: data, mainStat: mainStat)){
                inference.populate(aggregateData: data, mainStat: mainStat, timeFrame: timeFrame, graphData: graphData)
                objectsToImplement.append(inference)
            }
        }
    }
    func setObjectInFocus(index: Int){
        objectInFocus = index
    }
}

fileprivate class minimum : InferenceObjectBase {
    var title: String
    var subTitle: String
    var box: AnyView
    var data: [Double]
    var minimum: Double
    var minIndex: Int
    var timeMin: Date
    required init(){
        title = ""
        subTitle = ""
        box = AnyView(EmptyView())
        data = []
        minimum = 0.0
        minIndex = 0
        timeMin = Date()
    }
    func getGraphView(width: Double, height: Double, graphData: [Double], dataRange: Double?, dataMin: Double?) -> AnyView {
        return AnyView(GraphInferenceMinMaxGraphView(minimum: minimum, minIndex: minIndex, dataRange: dataRange!, dataMin: dataMin!, graphData: graphData, width: width, height: height, color: Color.purple, gradient: Gradient(colors: [.green, .blue])))//.scaleEffect(CGSize(width: 1.0, height: -1.0)))
        //flip because graph is flipped (pls dont ask why)
    }
    func isValid(aggregateData: aggregateDataObject, mainStat: String?) -> Bool {
        return (mainStat != nil)
    }
    //This function will abort if mainstat is ever nil but this is ok because we make sure the mainstat
    //is not nil in the valid check
    //fix the padding and formatting for inference box to be a little bigger and us a color for the text
    //fix mainUIBox to pass an optional main stat to fullscreenView
    //fix the logic which causes the view to appear and disappear, probably a binding to lineGraph, of
    //the inferece object
    func populate(aggregateData: aggregateDataObject, mainStat: String?, timeFrame: Calendar.Component, graphData: [(Double, Date)]?) {
        print("Populating minimum with data for \(mainStat!)")
        let mainData = aggregateData.statData[mainStat!]
        data = graphData!.map{$0.0}
        minimum = data.min()!
        let timeMinIndex = graphData!.map{$0.0}.firstIndex(of: minimum)
        minIndex = timeMinIndex!
        timeMin = graphData!.map{$0.1}[timeMinIndex!]
        title = "minimum"
        switch timeFrame{
        case .minute: subTitle = "over 15 minutes"
        case .hour: subTitle = "over an hour"
        case .day: subTitle = "over a day"
        case .month: subTitle = "over a month"
        default: subTitle = ""
        }
        box =
        AnyView(
            InferenceBox(title: title, subTitle: subTitle, titleColor: .purple){
                RingChart(progress: .constant(0.3), text: .constant(String(format: "%.1f", minimum)), color: .purple)
                    .padding()
                Text(getTimeComponent(date: timeMin, timeFrame: getTimeRangeVal(dates: mainData!.map{$0.1})))
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.systemGray3))
            }
        )
    }
}

struct InferenceBox<Content: View>: View {
    var title : String
    var subTitle: String
    var titleColor: Color
    @ViewBuilder var content: Content
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(titleColor)
                .fontWeight(.bold)
                .padding(.top, 5)
            Text(subTitle)
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray3))
                .padding(.bottom, -5)
            Divider()
            content
        }
        .background(Color(UIColor.black.withAlphaComponent(0.4)))
        .frame(width: UIScreen.main.bounds.size.width/2 - 30, height: 200)
        .cornerRadius(20)
    }
}
