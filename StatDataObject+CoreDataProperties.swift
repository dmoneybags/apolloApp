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
        if !dataStr.contains(","){
            let components = dataStr.components(separatedBy: ",")
            data.append(NSNumber(value: (components[0] as NSString).doubleValue))
            dates.append(Date(timeIntervalSince1970: (components[1] as NSString).doubleValue) as NSDate)
        } else {
            data.append(NSNumber(value: dataNSstr.doubleValue))
            dates.append(Date() as NSDate)
        }
    }
}

extension StatDataObject : Identifiable {

}
func getStatDataObject(stats: [StatDataObject], name: String) -> StatDataObject{
    return stats[stats.firstIndex(where: {$0.name == name})!]
}
func fetchStatDataObjects() -> [StatDataObject]{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedObject = fetchSpecificStatDataObject(named: name)
    fetchedObject.updateData(dataStr: characters)
    try? managedObjectContext.save()
}
