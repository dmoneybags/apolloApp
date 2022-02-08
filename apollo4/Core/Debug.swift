//
//  Debug.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/28/22.
//

import Foundation
//Writes one random data point per minute
func writeRandomDataTo(statObject: StatDataObject, num: Int){
    let statInfoObject = getStatInfoObject(named: statObject.name ?? "error")!
    let label = statInfoObject.labels[2]
    let yIntercept = statInfoObject.getRange(label: label).0
    let start = Date().timeIntervalSince1970 - TimeInterval(600 * num)
    var slope = Double.random(in: -0.001..<0.001)
    statObject.data = []
    statObject.dates = []
    for i in 0..<num {
        let value = yIntercept + (Double(i) * slope) + Double.random(in: 0..<5)
        let time = start + TimeInterval(600 * i)
        if i % 100 == 99{
            slope = slope + Double.random(in: -0.0002..<0.0007 * Double.random(in: 0..<3) * Double.random(in: 0..<3))
        }
        if value < Double(statInfoObject.maxVal){
            statObject.data.append(value as NSNumber)
        } else {
            statObject.data.append(statInfoObject.maxVal as NSNumber)
            slope = slope * -1
        }
        statObject.dates.append(Date(timeIntervalSince1970: time) as NSDate)
    }
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    try? managedObjectContext.save()
}
func writeRandomDataToV2(statObject: StatDataObject, num: Int){
    let statInfoObject = getStatInfoObject(named: statObject.name ?? "error")!
    let label = statInfoObject.labels[2]
    let yIntercept = statInfoObject.getRange(label: label).0
    let start = Date().timeIntervalSince1970 - TimeInterval(600 * num)
    statObject.data = []
    statObject.dates = []
    statObject.data.append(NSNumber(value: (Double.random(in: 0..<1) < 0.5 ? -1 : 1) + yIntercept))
    statObject.dates.append(Date(timeIntervalSince1970: start) as NSDate)
    for i in 1..<num - 1{
        let movement = Double.random(in: 0..<1) < 0.5 ? -1 : 1.05
        var value = min(Double(statObject.data[i - 1]) + Double(movement), Double(statInfoObject.maxVal))
        value = max(value, Double(statInfoObject.minVal))
        statObject.data.append(value as NSNumber)
        let time = start + TimeInterval(600 * i)
        statObject.dates.append(Date(timeIntervalSince1970: time) as NSDate)
    }
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    try? managedObjectContext.save()
}
func writeAllStats(num: Int){
    let statObjects: [StatDataObject] = [fetchSpecificStatDataObject(named: "HeartRate"), fetchSpecificStatDataObject(named: "SPO2"), fetchSpecificStatDataObject(named: "SystolicPressure"), fetchSpecificStatDataObject(named: "DiastolicPressure")]
    for statObject in statObjects {
        clearData(statObject: statObject)
        writeRandomDataToV2(statObject: statObject, num: num)
    }
}
func clearData(statObject: StatDataObject){
    writeRandomDataTo(statObject: statObject, num: 0)
}
func writeToCharacteristic(char: String, value: Int) -> Int{
    let peripheral = BLEManager.shared.connectedPeripheral
    if peripheral == nil {
        return 1
    }
    let characteristic = peripheral!.characteristics[char]
    if characteristic == nil {
        return 2
    }
    var mutableValue = value
    peripheral!._CBPeripheral.writeValue(Data(bytes: &mutableValue,
                                              count: MemoryLayout.size(ofValue: mutableValue)), for: characteristic!, type: .withoutResponse)
    return 0
}
func getMostRecentValue(statObject: StatDataObject) -> Double?{
    return statObject.data.last as! Double?
}
