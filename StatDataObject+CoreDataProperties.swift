//
//  StatDataObject+CoreDataProperties.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/11/21.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(StatDataObject)
public class StatDataObject: NSManagedObject {
}
extension StatDataObject {
    convenience init(inputName: String, context: NSManagedObjectContext, empty: Bool){
        self.init(context: context)
        name = inputName
        data = empty ? [] : getData(filename: getDocumentsDirectory().appendingPathComponent(name!), timeFrame: .year).map{NSNumber(value: $0.0)}
        dates = empty ? [] : getData(filename: getDocumentsDirectory().appendingPathComponent(name!), timeFrame: .year).map{ $0.1 as NSDate }
    }
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatDataObject> {
        return NSFetchRequest<StatDataObject>(entityName: "StatDataObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var data: [NSNumber]
    @NSManaged public var dates: [NSDate]
    var lastUpdated: Date {
        let dataList = data as? [(Double, Date)]
        return (dataList?.last?.1)!
    }
    func updateData(dataStr: String){
        print("----------writing-----------")
        let dataNSstr = dataStr as! NSString
        if dataStr.contains(","){
            let components = dataStr.components(separatedBy: ",")
            data.append(NSNumber(value: (components[0] as NSString).doubleValue))
            dates.append(Date(timeIntervalSince1970: (components[1] as NSString).doubleValue) as NSDate)
        } else {
            data.append(NSNumber(value: dataNSstr.doubleValue))
            dates.append(Date() as NSDate)
        }
    }
    func generateTupleData() -> [(Double, Date)]{
        var tupleData : [(Double, Date)] = []
        var index = 0
        for value in data{
            if value != 0 {
                tupleData.append((value as! Double, dates[index] as Date))
            }
            index += 1
        }
        return tupleData
    }
    func slimData(to num: Int, within timeFrame: Calendar.Component) -> [(Double, Date)]{
        let data: [(Double, Date)] = generateTupleData()
        var filteredData: [(Double, Date)] = filterDataTuples(forData: data, in: timeFrame)
        while filteredData.count > num {
            let medianTimeDiff = getMedianTimeDiff(forTuples: filteredData)
            for i in stride(from: filteredData.count - 2, to: 0, by: -1){
                if (filteredData[i + 1].1.timeIntervalSince1970 - filteredData[i].1.timeIntervalSince1970) < medianTimeDiff {
                    filteredData.remove(at: i + 1)
                }
            }
        }
        return filteredData
    }
    func getMedianTimeDiff(forTuples dataTuples: [(Double, Date)]) -> Double {
        var differenceList: [Double] = []
        let dateList = dataTuples.map{$0.1}
        for i in 0..<dateList.count - 2 {
            differenceList.append(dateList[i + 1].timeIntervalSince1970 - dateList[i].timeIntervalSince1970)
        }
        return differenceList.sorted(by: <)[differenceList.count / 2]
    }
}

extension StatDataObject : Identifiable {

}
func getStatDataObject(stats: [StatDataObject], name: String) -> StatDataObject{
    return stats[stats.firstIndex(where: {$0.name == name})!]
}
func fetchStatDataObjects() -> [StatDataObject]{
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<StatDataObject> = StatDataObject.fetchRequest()
    do {
        let StatDataObjects = try managedObjectContext.fetch(fetchRequest)
        return StatDataObjects
    } catch {
        print("Error fetching StatDataObjects: \(error.localizedDescription)")
    }
    return [StatDataObject]()
}
func fetchSpecificStatDataObject(named name: String) -> StatDataObject{
    let objects = fetchStatDataObjects()
    let filteredObject = getStatDataObject(stats: objects, name: name)
    return filteredObject
}
func updateStatDataObject(withString characters: String, statNamed name: String){
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    let fetchedObject = fetchSpecificStatDataObject(named: name)
    fetchedObject.updateData(dataStr: characters)
    try? managedObjectContext.save()
}
func filterDataTuples(forData data: [(Double, Date)], in timeFrame: Calendar.Component, from start: Int? = nil, to finish: Int? = nil) -> [(Double, Date)]{
    var increment = 1
    var filteredData : [(Double, Date)] = []
    while filteredData.isEmpty {
        let calendar = Calendar.current
        let componentStart = start ?? calendar.component(timeFrame, from: Date()) - increment
        let componentFinish = finish ?? calendar.component(timeFrame, from: Date())
        for value in data {
            let timeVal = calendar.component(timeFrame, from: value.1)
            if (componentStart < timeVal) && (timeVal <= componentFinish) {
                filteredData.append(value)
            }
        }
        increment += 1
    }
    return filteredData
}
func filterData(forData data: [(Double, Date)], in timeFrame: Calendar.Component, from start: Int? = nil, to finish: Int? = nil) -> [Double]{
    var increment = 1
    var filteredData : [Double] = []
    while filteredData.isEmpty {
        let calendar = Calendar.current
        let componentStart = start ?? calendar.component(timeFrame, from: Date()) - increment
        let componentFinish = finish ?? calendar.component(timeFrame, from: Date())
        for value in data {
            let timeVal = calendar.component(timeFrame, from: value.1)
            if (componentStart < timeVal) && (timeVal <= componentFinish) {
                filteredData.append(value.0)
            }
        }
        increment += 1
    }
    return filteredData
}
func filterDates(forData data: [(Double, Date)], in timeFrame: Calendar.Component, from start: Int? = nil, to finish: Int? = nil) -> [Date]{
    var increment = 1
    var filteredData : [Date] = []
    while filteredData.isEmpty {
        let calendar = Calendar.current
        let componentStart = start ?? calendar.component(timeFrame, from: Date()) - increment
        let componentFinish = finish ?? calendar.component(timeFrame, from: Date())
        for value in data {
            let timeVal = calendar.component(timeFrame, from: value.1)
            if (componentStart < timeVal) && (timeVal <= componentFinish) {
                filteredData.append(value.1)
            }
        }
        increment += 1
    }
    return filteredData
}

