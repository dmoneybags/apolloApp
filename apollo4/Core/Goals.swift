//
//  Goals.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/27/22.
//

import Foundation

struct GoalSetting: Codable {
    let key: String
    var stat: String
    var above: Bool
    var value: Double
    var timeInterval: Int
    init(value: Double, above: Bool, timeInterval: Calendar.Component, stat: Stat){
        self.key = stat.name + "_GOAL_SETTING"
        self.stat = stat.name
        self.above = above
        self.value = value
        self.timeInterval = getNumSeconds(in: timeInterval)
    }
}
func setGoal(goalSetting: GoalSetting){
    let encoder = JSONEncoder()
    do {
        UserDefaults.standard.set(try encoder.encode(goalSetting), forKey: goalSetting.key)
        print("GOALS::ENCODING SUCCEEDED")
    } catch {
        print("GOALS::ENCODING FAILED")
    }
}
func getGoalSetting(for stat: String) -> GoalSetting?{
    let key = stat  + "_GOAL_SETTING"
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    do {
        let setting = defaults.object(forKey: key)
        if setting != nil {
            let goalSetting = try decoder.decode(GoalSetting.self, from: setting as! Data)
            return goalSetting
        }
        return nil
    } catch {
        print("GOALS::Could not decode or no setting is placed, exiting and returning false")
        return nil
    }
}
func handleGoalNotification(stat: String){
    let goalSetting = getGoalSetting(for: stat)
    if goalSetting != nil {
        let statDataObject = fetchSpecificStatDataObject(named: stat)
        let statInfoObject = getStatInfoObject(named: stat)
        let dataFrame = statDataObject.generateTupleData()
        let averageValue = averageData(data: dataFrame.map{$0.0})
        if goalSetting!.above {
            if averageValue > goalSetting!.value {
                sendNotification(title: "You hit your goal!", subtitle: "Check your " + statInfoObject!.displayName + "in the app.")
            }
        } else {
            if averageValue < goalSetting!.value {
                sendNotification(title: "You hit your goal!", subtitle: "Check your " + statInfoObject!.displayName + "in the app.")
            }
        }
    }
}

