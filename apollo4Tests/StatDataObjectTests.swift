//
//  StatDataObjectTests.swift
//  apollo4Tests
//
//  Created by Daniel DeMoney on 1/31/22.
//

import XCTest
@testable import apollo4
class StatDataObjectTests: XCTestCase {
    var statDataObject : StatDataObject? = nil
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let managedObjectContext = AppDelegate.originalAppDelegate.persistentContainer.viewContext
        statDataObject = StatDataObject(inputName: "HeartRate", context: managedObjectContext, empty: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func checkSlimData() throws {
        
    }

    func testPerformanceExample() throws {
        writeRandomDataToV2(statObject: statDataObject!, num: 15000)
        self.measure {
            let aggregateObject = aggregateDataObject(stats: [statDataObject!], within: .year)
        }
        var statData : [(Double, Date)] =  []
    }
    
}
