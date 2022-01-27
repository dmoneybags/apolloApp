//
//  Notifications.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/26/22.
//

import Foundation
import UserNotifications

struct NotificationSetting: Codable {
    let stat: String
    var value: Double
    var above: Bool
    var usesAverage: Bool
    //Num seconds
    var averageTimeFrame: Int
    var on: Bool = true
}

func sendNotification(title: String, subtitle: String, sound: UNNotificationSound = UNNotificationSound.default){
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.sound = sound
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
func CheckAndSendNotification(stat: String, value: Double){
    let key = stat  + "_NOTIFICATION_SETTING"
    let defaults = UserDefaults.standard
    let setting = defaults.object(forKey: key) as! Data
    let decoder = JSONDecoder()
    var notificationSetting = NotificationSetting(stat: "", value: 0, above: false, usesAverage: false, averageTimeFrame: 0, on: false)
    do {
        notificationSetting = try decoder.decode(NotificationSetting.self, from: setting)
    } catch {
        print("NOTIFICATIONS::Could not decode or no setting is placed, exiting and returning false")
        return
    }
    var titlePrefix = ""
    let statName = getStatInfoObject(named: stat)!.displayName
    var subtitle = "Tap to check on your " + statName
    //if the notification is on
    if notificationSetting.on {
        //if its above
        if notificationSetting.above{
            titlePrefix = "High "
            if value > notificationSetting.value {
                //Its above the level return true
                sendNotification(title: titlePrefix + statName, subtitle: subtitle)
            } else  {
                //its below return
               return
            }
        //its below
        } else {
            //if its less than
            titlePrefix = "Low "
            if value <  notificationSetting.value {
                //return true
                sendNotification(title: titlePrefix + statName, subtitle: subtitle)
            } else {
                //its not return
                return
            }
        }
    } else {
        // its off don't send a notification
        return
    }
}
