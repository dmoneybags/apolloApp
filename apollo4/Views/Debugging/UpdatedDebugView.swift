//
//  UpdatedDebugView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/28/22.
//

import SwiftUI
import NotificationBannerSwift

struct UpdatedDebugView: View {
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    @State private var showingView: Bool = false
    @State private var writingChacteristic: Bool = false
    @State private var statInQuestion: StatDataObject? = nil
    var body: some View {
        VStack{
            Text("Debugging")
                .fontWeight(.bold)
                .font(.largeTitle)
            ScrollView{
                VStack{
                    ForEach(stats.indices, id: \.self){indice in
                        let stat = stats[indice]
                        Button{
                            statInQuestion = stat
                            showingView = true
                        } label: {
                            Text(stat.name!)
                        }
                        .frame(height: 60)
                    }
                    Button {
                        writingChacteristic = true
                    } label: {
                        Text("Write Characteristic")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingView){
                StatDebugView(stat: statInQuestion ?? stats[0])
            }
            .fullScreenCover(isPresented: $writingChacteristic){
                CharacteristicDebugView()
            }
        }
        .padding(.top, 80)
        .onAppear(){
            for stat in stats{
                print(stat.name)
            }
        }
    }
}

struct UpdatedDebugView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatedDebugView()
            .preferredColorScheme(.dark)
    }
}
struct StatDebugView: View {
    var stat: StatDataObject
    @State private var numToAdd: Int = 0
    var body: some View{
        let statInfoObject = getStatInfoObject(named: stat.name ?? "")
        NavigationView{
            BasicSettingView(title: "Debug " + (stat.name ?? "Unknown Stat")){
                Form{
                    Section(header: Text("Most Recent value")){
                        let value = stat.data.last as? Double
                        let valueStr = value == nil ? nil:  String(value!)
                        Text(valueStr ?? "No Data")
                        Text("Max \(stat.data.map{$0 as! Double}.max() ?? 0.0)")
                        if statInfoObject != nil{
                            Text("Proper Range \(getProperGraphRange(data: stat.data.map{$0 as! Double}, stat: statInfoObject!))")
                        }
                        
                    }
                    Section(header: Text("Add data")){
                        Stepper("\(numToAdd) values", value: $numToAdd, in: 0...10000, step: 500)
                        Button {
                            writeRandomDataToV2(statObject: stat, num: numToAdd)
                        } label: {
                            Text("Add")
                        }
                    }
                    Section(header: Text("Clear Data")){
                        Button{
                            clearData(statObject: stat)
                        } label: {
                            Text("Clear")
                        }
                    }
                }
            }
        }
    }
    func getProperGraphRange(data: [Double], stat: Stat) -> Double{
        var min = min(data.min() ?? 10000.0, Double(stat.minVal))
        print(min)
        return max((data.max() ?? 100) - min, Double(stat.maxVal) - min)
    }
}
struct CharacteristicDebugView: View {
    @State var characteristicNameChosen: String = ""
    @State var dataToWrite: Int = 0
    @State var returnVal: Int = -1
    let successNotification = NotificationBanner(title: "Success", subtitle: "Characteristic written", style: .success)
    let errorNotification = NotificationBanner(title: "Error", subtitle: "Characteristic failed to write", style: .success)
    var body: some View {
        NavigationView{
            BasicSettingView(title: "Debug a Characteristic"){
                Form{
                    Section(header: Text("Pick a characteristic")){
                        Picker("Characteristic Name:", selection: $characteristicNameChosen){
                            ForEach(Array(CBUUIDs.characteristicsDict.values).indices, id:\.self){indice in
                                let name = Array(CBUUIDs.characteristicsDict.values)[indice]
                                if !CBUUIDs.shouldWriteStatObject(namestr: name){
                                    Text(name).tag(name)
                                }
                            }
                        }
                        Picker("Data to write:", selection: $dataToWrite){
                            ForEach(0..<100){
                                Text("\($0)")
                            }
                        }
                        Button{
                            returnVal =  writeToCharacteristic(char: characteristicNameChosen, value: dataToWrite)
                        } label: {
                            Text("Write Data")
                        }
                    }
                }
            }
        }
        .onChange(of: returnVal){val in
            if returnVal == 0{
                successNotification.show()
            } else {
                errorNotification.show()
            }
        }
    }
}
