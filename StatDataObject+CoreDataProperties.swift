//
//  StatDataObject+CoreDataProperties.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/11/21.
//
//
// Main file for statDataObjects
import Foundation
// A coreData model, read more here: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html
import CoreData
import SwiftUI

@objc(StatDataObject)
public class StatDataObject: NSManagedObject {
}
extension StatDataObject {
    //EMPTY is only for debugging, pulls data from legacy csv files, not intended for real use
    //We pass in a managed object context so we know which environment the object will exist in
    convenience init(inputName: String, context: NSManagedObjectContext, empty: Bool){
        self.init(context: context)
        //How we will define and grab the object
        name = inputName
        //doubles
        data = empty ? [] : getData(filename: getDocumentsDirectory().appendingPathComponent(name!), timeFrame: .year).map{NSNumber(value: $0.0)}
        //dates corresponding
        dates = empty ? [] : getData(filename: getDocumentsDirectory().appendingPathComponent(name!), timeFrame: .year).map{ $0.1 as NSDate }
    }
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatDataObject> {
        return NSFetchRequest<StatDataObject>(entityName: "StatDataObject")
    }
    @NSManaged public var name: String?
    @NSManaged public var data: [NSNumber]
    @NSManaged public var dates: [NSDate]
    var statInfo: Stat? {
        return getStatInfoObject(named: name ?? "nil")
    }
    //will return the last time we got data
    var lastUpdated: Date {
        let dataList = data as? [(Double, Date)]
        return (dataList?.last?.1)!
    }
    //adds data to statObject
    func updateData(dataStr: String){
        //don't write 0s, ideally this is caught on the C side, but can never be too safe
        if dataStr == "0" || dataStr == "0.0" || dataStr == "0.00"{
            print("STATDATAOBJECT::Found 0, write failed")
            return
        }
        print("STATDATAOBJECT::----------writing-----------")
        let dataNSstr = dataStr as NSString
        //Not currently used but if theres a comma this means theres a timestamp being sent
        //with it and we should use that time as the timestamp
        if dataStr.contains(","){
            let components = dataStr.components(separatedBy: ",")
            data.append(NSNumber(value: (components[0] as NSString).doubleValue))
            dates.append(Date(timeIntervalSince1970: (components[1] as NSString).doubleValue) as NSDate)
        } else {
            //append the double to data and current date to dates
            print("STATDATAOBJECT::\(#function) adding \(dataStr) to \(String(describing: self.name)) at \(Date())")
            data.append(NSNumber(value: dataNSstr.doubleValue))
            dates.append(Date() as NSDate)
        }
        MostRecentValues.valueDict[name!] = dataNSstr.doubleValue
        MostRecentValues.timeDict[name!] = Int(Date().timeIntervalSince1970)
    }
    //Changes the data representation from 2 separated lists to one
    func generateTupleData() -> [(Double, Date)]{
        let tupleData : [(Double, Date)] = zip(data, dates).map{($0 as! Double, $1 as Date)}
        return tupleData
    }
    //Method to slim tuples to a certain number by removing tuples with smallest interval
    //between them
    //Change to use offset as well... I won't right now because Im high... shhh dont tell anyone
    func slimData(to num: Int, within timeFrame: Calendar.Component) -> [(Double, Date)]{
        //Grab tuples
        var filteredData: [(Double, Date)] = filterDataTuples(forData: generateTupleData(), in: timeFrame)
        if filteredData.count > num{
            let dateList = filteredData.map{$0.1}
            //Seconds from previous time, Index
            var timeTupleList: [(Double, Int)] = []
            for i in filteredData.indices {
                //first one is always kept
                if i == 0 {
                    continue
                } else {
                    timeTupleList.append((dateList[i].timeIntervalSince1970 - dateList[i - 1].timeIntervalSince1970, i))
                }
            }
            //Order list so that the times with most seconds between are first
            timeTupleList = timeTupleList.sorted(by: {$0.0 > $1.0})
            //slice list to get the "num" amount of times with lowest time difference
            var timesToRemove: [(Double, Int)] = timeTupleList.suffix(filteredData.count - num)
            //Sort time so that indexs are in decreasing order to not cause index errors when
            //removing
            timesToRemove = timesToRemove.sorted(by: {$0.1 > $1.1})
            for tupleVal in timesToRemove {
                filteredData.remove(at: tupleVal.1)
            }
        }
        print("STATDATAOBJECT::\(#function) returning tuples of \(filteredData)")
        return filteredData
    }
}

extension StatDataObject : Identifiable {

}
extension Date {
    //Extension of date to get start values for
    func startOf(_ dateComponent : Calendar.Component) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())!
        var startOfComponent = self
        var timeInterval : TimeInterval = 0.0
        var didWork = calendar.dateInterval(of: dateComponent, start: &startOfComponent, interval: &timeInterval, for: self)
        if !didWork {
            print("STATDATAOBJECT::couldn't convert \(self)")
        }
        return startOfComponent
    }
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
            return calendar.dateComponents(Set(components), from: self)
        }

        func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
            return calendar.component(component, from: self)
        }
}
//filters a list already produced to get a specific object
func getStatDataObject(stats: [StatDataObject], name: String) -> StatDataObject{
    print("STATDATAOBJECT::getting object for \(name)")
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    if stats.first(where: {$0.name == name}) == nil {
        print("STATDATAOBJECT::couldn't find \(name)")
    }
    return stats.first(where: {$0.name == name}) ?? StatDataObject(inputName: name, context: managedObjectContext, empty: true)
}
//gets our stat data objects
func fetchStatDataObjects() -> [StatDataObject]{
    //Grab moc from app delegate
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<StatDataObject> = StatDataObject.fetchRequest()
    do {
        let StatDataObjects = try managedObjectContext.fetch(fetchRequest)
        print("STATDATAOBJECT::Got stat objects")
        for i in StatDataObjects{
            print(i.name)
        }
        return StatDataObjects
    } catch {
        print("STATDATAOBJECT::Error fetching StatDataObjects: \(error.localizedDescription)")
    }
    print("STATDATAOBJECT::Couldnt grab stat objects, returning empty list")
    return [StatDataObject]()
}
//Grabs a specific stat object by calling a fetch request for all them and then filtering
//expensive, not really used
func fetchSpecificStatDataObject(named name: String) -> StatDataObject{
    print("STATDATAOBJECT::Doing fetch request for \(name)")
    let objects = StatDataObjectListWrapper.stats
    let filteredObject = getStatDataObject(stats: objects, name: name)
    return filteredObject
}
//Called by bleManager to update coreData model with new data
func updateStatDataObject(withString characters: String, statNamed name: String){
    let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
    let fetchedObject = fetchSpecificStatDataObject(named: name)
    fetchedObject.updateData(dataStr: characters)
    //We save at the end
    try? managedObjectContext.save()
}
//UNUSED
fileprivate func getMedianTimeDiff(forTuples dataTuples: [(Double, Date)]) -> Double {
    var differenceList: [Double] = []
    let dateList = dataTuples.map{$0.1}
    for i in 0..<dateList.count - 2 {
        differenceList.append(dateList[i + 1].timeIntervalSince1970 - dateList[i].timeIntervalSince1970)
    }
    return differenceList.sorted(by: <)[differenceList.count / 2]
}
//Gets the date given the timeframe and offset. This is used to give our data a frame. For example,
//We last got data at 7:18am on 11/23/2021, if timeframe was day and offset was 0 this would return 12:00am on 11/23/2021 to give us a frame for the day we need to catch with it, if offset was one we would go back to the date before that
//returns seconds since 1970 at start of the frame which we wish to capture
func getMostRecentDate(usingDates dates: [Date], in timeFrame: Calendar.Component, withOffset offset: Int? = 0) -> TimeInterval {
    //just an initialization value that we know will never be equal to any timeframe we have
    var dateValue : Date = Date(timeIntervalSince1970: 1000000)
    //datesPassed is the functions implementation of an offset
    var datesPassed : Int = 0
    //order dates so that most recent dates are first
    for date in dates.sorted(by: {($0 as NSDate).timeIntervalSince1970 > ($1 as NSDate).timeIntervalSince1970}){
        if dateValue != date.startOf(timeFrame){
            dateValue = date.startOf(timeFrame)
            datesPassed += 1
        }
        if datesPassed >= (offset ?? 0) + 1 {
            return dateValue.timeIntervalSince1970
        }
    }
    print("STATDATAOBJECT::Returning from getMost recent Date with \(dateValue)")
    return dateValue.timeIntervalSince1970
}
//Gets the number of dates in month for getNumSeconds method
func getNumDaysMonth(forMonth month: Int, forYear year: Int) -> Int {
    let dateComponents = DateComponents(year: year, month: month)
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!
    let range = calendar.range(of: .day, in: .month, for: date)!
    return range.count
}
//given a timeframe and month and year number, returns number of seconds in the frame
func getNumSeconds(in timeframe: Calendar.Component, forMonth month: Int = 1, forYear year: Int = 2022) -> Int {
    switch timeframe {
    case .minute: return 60
    case .hour: return 3600
    case .day: return 3600 * 24
    case .weekOfYear: return 3600 * 24 * 7
    case .month: return getNumDaysMonth(forMonth: month, forYear: year) * 3600 * 24
    case .year: return 3600 * 24 * 7 * 52
    default: return 1
    }
}
//Combines our starting time with our timeframe to return the finishing time
fileprivate func getFinishingDate(with start: TimeInterval, in timeFrame: Calendar.Component) -> TimeInterval {
    let startDate = Date(timeIntervalSince1970: start)
    return start + Double(getNumSeconds(in: timeFrame, forMonth: startDate.get(.month), forYear: startDate.get(.year)))
}
//OPTIMIZE
//Takes in tuples, a timeFrame and an offset to return data values from that point
func filterDataTuples(forData data: [(Double, Date)], in timeFrame: Calendar.Component, from start: TimeInterval? = nil, to finish: TimeInterval? = nil, withOffset offset: Int? = nil) -> [(Double, Date)]{
    var filteredData : [(Double, Date)] = []
    if data.isEmpty{
        return data
    }
    while filteredData.isEmpty {
        let componentStart = start ?? getMostRecentDate(usingDates: data.map{$0.1}, in: timeFrame, withOffset: offset)
        let componentFinish = finish ?? getFinishingDate(with: componentStart, in: timeFrame)
        for value in data {
            let timeVal = value.1.timeIntervalSince1970
            if (componentStart < timeVal) && (timeVal <= componentFinish) {
                filteredData.append(value)
            }
        }
    }
    return filteredData
}
//combines previous slimdata and filter all in one
func slimDataTuples(forData data: [(Double, Date)], to num: Int, within timeFrame: Calendar.Component, withOffset offset: Int? = nil) -> [(Double, Date)]{
    var filteredData: [(Double, Date)] = filterDataTuples(forData: data, in: timeFrame, withOffset: offset)
    if filteredData.count > num{
        let dateList = filteredData.map{$0.1}
        //Seconds from previous time, Index
        var timeTupleList: [(Double, Int)] = []
        for i in filteredData.indices {
            if i == 0 {
                continue
            } else {
                timeTupleList.append((dateList[i].timeIntervalSince1970 - dateList[i - 1].timeIntervalSince1970, i))
            }
        }
        timeTupleList = timeTupleList.sorted(by: {$0.0 > $1.0})
        var timesToRemove: [(Double, Int)] = timeTupleList.suffix(filteredData.count - num)
        timesToRemove = timesToRemove.sorted(by: {$0.1 > $1.1})
        for tupleVal in timesToRemove {
            filteredData.remove(at: tupleVal.1)
        }
    }
    return filteredData
}
//create moving average func
func movingAverage(previousAverage: inout Double, count: inout Double, newValue: Double){
    count += 1
    previousAverage = ((previousAverage * (count - 1)) + newValue)/count
}
func getTemporallyPooledData(forData data: [(Double, Date)], within timeFrame: Calendar.Component, withOffset offset: Int? = nil, poolTimeFrame: Calendar.Component, num: Int) -> [(Double, Date)]{
    if data.isEmpty{
        return []
    }
    if data.count < 5 {
        return data
    }
    let filteredData: [(Double, Date)] = filterDataTuples(forData: data, in: timeFrame, withOffset: offset)
    let poolSeconds = getNumSeconds(in: poolTimeFrame) * num
    var poolTimeFrameStart: Int = Int(filteredData[0].1.timeIntervalSince1970) - Int(filteredData[0].1.timeIntervalSince1970) % poolSeconds
    var poolTimeFrameEnd: Int = Int(poolTimeFrameStart) + poolSeconds
    var pooledData: [(Double, Date)] = []
    var curlen: Double = 0
    var previousMean: Double = 0
    for tuple in filteredData {
        let tupleTime: Int = Int(tuple.1.timeIntervalSince1970)
        if (tupleTime > poolTimeFrameStart) && (tupleTime < poolTimeFrameEnd){
            movingAverage(previousAverage: &previousMean, count: &curlen, newValue: tuple.0)
        } else {
            pooledData.append((previousMean, Date(timeIntervalSince1970: TimeInterval(poolTimeFrameStart))))
            curlen = 0
            previousMean = 0
            poolTimeFrameStart = tupleTime - (tupleTime % poolSeconds)
            poolTimeFrameEnd = poolTimeFrameStart + poolSeconds
            movingAverage(previousAverage: &previousMean, count: &curlen, newValue: tuple.0)
        }
    }
    //"Finally add the last one"
    pooledData.append((previousMean, Date(timeIntervalSince1970: TimeInterval(poolTimeFrameStart))))
    print("STATDATAOBJECT::got pooled data")
    return pooledData
}
func setPoolTimeFrame(data: [(Double, Date)], maxTimeFrame: inout Calendar.Component, maxNum: inout Int, within timeFrame: Calendar.Component, withOffset offset: Int? = nil){
    if data.isEmpty{
        return
    }
    let filteredData: [(Double, Date)] = filterDataTuples(forData: data, in: timeFrame, withOffset: offset)
    let timeIntervalList : [(Calendar.Component, Int)] = [(.month, 1), (.day, 1), (.hour, 1), (.minute, 30), (.minute, 15), (.minute, 10), (.minute, 5), (.minute, 1), (.second, 10)]
    let timeDifference = Int(filteredData.last!.1.timeIntervalSince1970 - filteredData[0].1.timeIntervalSince1970)
    let appropriateTimeDiff = timeDifference/4
    let preferredTimeDiff = getNumSeconds(in: maxTimeFrame)
    for tuple in timeIntervalList {
        if getNumSeconds(in: tuple.0) * tuple.1 < appropriateTimeDiff{
            maxTimeFrame = tuple.0
            maxNum = tuple.1
            return
        }
    }
    return
}
