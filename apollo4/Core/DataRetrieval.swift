//
//  DataRetrieval.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/23/21.
//

import Foundation
func getData(filename: URL, timeFrame: Calendar.Component) -> [(Double, Date)] {
    var data: [(Double, Date)] = []
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    let contents = try! String(contentsOf: filename)
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        let lineTuple = line.components(separatedBy: ",")
        let date = dateFormatter.date(from: lineTuple[0])
        if date == nil {
            continue
        }
        let now = Date()
        let component = calendar.component(timeFrame, from: date!)
        let componentNow = calendar.component(timeFrame, from: now)
        if component == componentNow {
            data.append((Double((lineTuple[1] as NSString).doubleValue), date!))
        }
    }
    print("GOT DATA FOR \(timeFrame)")
    print(data)
    return data
}
func averageData(data: [Double]) -> Double {
    var counter: Double = 0
    var total: Double = 0
    for i in data {
        counter = counter + 1
        total = total + Double(i)
    }
    return total/counter
}
func getMax(data: [Double]) -> Double {
    var max: Double = 0
    for i in data {
        if Double(i) > max {
            max = Double(i)
        }
    }
    return max
}
func getMin(data: [Double]) -> Double {
    var min: Double = 10000000
    for i in data {
        if Double(i) < min {
            min = Double(i)
        }
    }
    return min
}
func getRange(data: [Double]) -> Double {
    let min = getMin(data: data)
    let max = getMax(data: data)
    return max - min
}
