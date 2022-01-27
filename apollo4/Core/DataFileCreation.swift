//
//  DataFileCreation.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/25/22.
//

import Foundation

func createDataFile(stats: [StatDataObject], timeFrame: Calendar.Component, includeContactInfo: Bool, includeTrend: Bool) -> URL{
    let timeFrameList: [Calendar.Component] = [.minute, .hour, .day, .weekOfYear, .month, .year]
    var poolTimeFrame: Calendar.Component = timeFrameList[timeFrameList.firstIndex(of: timeFrame) ?? 1 - 1]
    var poolNum = 1
    setPoolTimeFrame(data: stats[0].generateTupleData(), maxTimeFrame: &poolTimeFrame, maxNum: &poolNum, within: timeFrame)
    var tupleDataDict: [String:[(Double, Date)]] = [:]
    for statObject in stats{
        tupleDataDict[statObject.name!] =  getTemporallyPooledData(forData: statObject.generateTupleData(), within: timeFrame, poolTimeFrame: poolTimeFrame, num: poolNum)
    }
    let dataLen = tupleDataDict[stats[0].name!]!.count
    var fileStr = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    fileStr.append("* Data Gathered From Apollo Ring\n")
    fileStr.append("* Data gathered for ")
    for i in 0..<stats.count{
        if i < stats.count - 1{
            fileStr.append("\(String((getStatInfoObject(named: stats[i].name!)!.displayName))), ")
        } else {
            fileStr.append("\(String(getStatInfoObject(named: stats[i].name!)!.displayName))\n")
        }
        
    }
    fileStr.append("* Data gathered from \(dateFormatter.string(from: tupleDataDict[stats[0].name!]![0].1)) -> \(dateFormatter.string(from: tupleDataDict[stats[0].name!]!.last!.1))\n")
    if includeContactInfo {
        fileStr.append("* Patient: \(UserData.shared.getFirstName() ?? "Unknown") \(UserData.shared.getLastName() ?? "Unknown")\n")
        fileStr.append("* Phone Number: \(UserData.shared.getPhoneNumber() ?? "Unknown")\n")
        fileStr.append("* Email: \(UserData.shared.getEmail() ?? "Unknown")\n")
    }
    if includeTrend{
        fileStr.append("* Trends: ")
        for stat in stats{
            let statData = tupleDataDict[stat.name!]!.map{$0.0}
            let trendPercent = getTrendPercent(dataFirst: statData[0], dataLen: statData.count, slope: calcLinearReg(data: statData).0, yIntercept: calcLinearReg(data: statData).1)
            fileStr.append("\(stat.name!): \(abs(trendPercent)) % \(trendPercent > 0 ? "Up" : "Down"): ")
        }
        fileStr.append("\n")
    }
    for indice in 0..<dataLen{
        fileStr.append("\(dateFormatter.string(from: tupleDataDict[stats[0].name!]![indice].1)): ")
        for stat in stats{
            fileStr.append("\(String(stat.name!)): \(Int(tupleDataDict[stat.name!]![indice].0)), ")
        }
        fileStr.append("\n")
    }
    print("DATAFILECREATION::Sending file of \n \(fileStr)")
    return writeDataFile(fileStr: fileStr)
}
func writeDataFile(fileStr: String) -> URL{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    let filename = getDocumentsDirectory().appendingPathComponent("My_Data.txt")
    print(filename)
    do {
        if !FileManager.default.fileExists(atPath: filename.absoluteString){
            FileManager.default.createFile(atPath: filename.absoluteString, contents: "".data(using: String.Encoding.utf8))
            print("DATAFILECREATION::CREATED FILE.")
        }
        let text = ""
        try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        try fileStr.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        print("DATAFILECREATION::Write Suceeded")
    } catch {
        print("DATAFILECREATION::Error info: \(error)")
    }
    print("DATAFILECREATION::RECIEVED URL OF \(filename)")
    return filename
}
