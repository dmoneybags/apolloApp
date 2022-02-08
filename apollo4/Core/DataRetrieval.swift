//
//  DataRetrieval.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/23/21.
//
//UNUSED DEPRECATED DO NOT USE
import Foundation
func getData(filename: URL, timeFrame: Calendar.Component) -> [(Double, Date)] {
        var data: [(Double, Date)] = []
        let calendar = Calendar.current
        var componentNow = calendar.component(timeFrame, from: Date())
        let contents = try! String(contentsOf: filename)
        while data.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let lines = contents.components(separatedBy: "\n")
            for line in lines {
                let lineTuple = line.components(separatedBy: ",")
                let date = dateFormatter.date(from: lineTuple[0])
                if date == nil {
                    continue
                }
                let component = calendar.component(timeFrame, from: date!)
                if component == componentNow {
                    data.append((Double((lineTuple[1] as NSString).doubleValue), date!))
                } else {
                    if !data.isEmpty{
                        break
                    }
                }
            }
            if data.isEmpty{
                componentNow = componentNow - 1
            }
        }
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
func createTupleData(data: [Double], dates: [Date]) -> [(Double, Date)]{
    var tupleData: [(Double, Date)] = []
    for i in 0..<data.count{
        tupleData.append((data[i], dates[i]))
    }
    return tupleData
}
