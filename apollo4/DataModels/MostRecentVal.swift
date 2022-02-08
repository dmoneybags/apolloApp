//
//  MostRecentVal.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/7/22.
//

import Foundation

struct MostRecentValues {
    static var valueDict: [String:Double] = genDict()
    static var timeDict: [String:Int] = genTimeDict()
    static func genDict() -> [String: Double]{
        var dict: [String:Double] = [:]
        let statInfoObjects: [Stat] = [HeartRate.shared, SPO2.shared, DiastolicPressure.shared, SystolicPressure.shared]
        for stat in statInfoObjects{
            dict[stat.name] = StatDataObjectListWrapper.stats.first(where: {$0.name == stat.name})!.data.last!.doubleValue
        }
        return dict
    }
    static func genTimeDict() -> [String: Int]{
        var dict: [String:Int] = [:]
        let statInfoObjects: [Stat] = [HeartRate.shared, SPO2.shared, DiastolicPressure.shared, SystolicPressure.shared]
        for stat in statInfoObjects{
            dict[stat.name] = Int((StatDataObjectListWrapper.stats.first(where: {$0.name == stat.name})!.dates.last! as Date).timeIntervalSince1970)
        }
        return dict
    }
    static func getTimeAgo(stat: String) -> String? {
        let mostRecentTime = MostRecentValues.timeDict[stat] ?? 0
        if mostRecentTime == 0 {
            return nil
        }
        return Date(timeIntervalSince1970: TimeInterval(mostRecentTime)).timeAgoDisplay()
    }
}
