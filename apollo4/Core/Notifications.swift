//
//  Notifications.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/26/22.
//
//TO DO: FLAG FOR IF STAT EXITS ALERTS AREA SO WE DONT CONSTANTLY ALERT
import Foundation
import UserNotifications
import BackgroundTasks

struct NotificationSetting: Codable {
    let stat: String
    var value: Double
    var above: Bool
    var usesAverage: Bool
    //Num seconds
    var averageTimeFrame: Int
    var on: Bool = true
    var timeLastSent: Date = Date()
}
//This struct holds the data for whether or not we should send the data
struct TimeFrameData {
    static let stats: [Stat] = [HeartRate.shared, SPO2.shared, SystolicPressure.shared, DiastolicPressure.shared]
    //Have we collected data for this stat in this timeFrame
    static var hasCollected: [String: Bool] = initializeHasCollected()
    //Seconds since epoch that we started collecting data
    static var timesCollected: [String: Int] = initializeTimesCollected()
    static var prevAverage: [String: Double] = initializePrevAverage()
    static func initializeHasCollected() -> [String: Bool]{
        var initialDict: [String: Bool] = [:]
        for stat in stats{
            initialDict[stat.name] = false
        }
        return initialDict
    }
    static func initializeTimesCollected() -> [String: Int]{
        var initialDict: [String: Int] = [:]
        for stat in stats {
            initialDict[stat.name] = 0
        }
        return initialDict
    }
    static func initializePrevAverage() -> [String: Double]{
        var initialDict: [String: Double] = [:]
        for stat in stats {
            initialDict[stat.name] = 0
        }
        return initialDict
    }
}
func stringToDouble(string: String) -> Double {
    return (string as NSString).doubleValue
}
func setNotificationInUserDefaults(setting: NotificationSetting){
    let key = setting.stat + "_NOTIFICATION_SETTING"
    let encoder = JSONEncoder()
    do {
        UserDefaults.standard.set(try encoder.encode(setting), forKey: key)
        print("AlertMeView::ENCODING SUCCEEDED")
    } catch {
        print("AlertMeView::ENCODING FAILED")
    }
}
func handleNotificationRefresh(stat: String){
    var notificationSetting = getNotificationSetting(for: stat)
    let statInfoObject = getStatInfoObject(named: stat)!
    if notificationSetting != nil && notificationSetting!.usesAverage{
        TimeFrameData.prevAverage[stat] = 0
        TimeFrameData.timesCollected[stat] = 0
        if TimeFrameData.hasCollected[stat]! {
            TimeFrameData.hasCollected[stat] = false
            if notificationSetting!.above {
                if TimeFrameData.prevAverage[stat]! > notificationSetting!.value {
                    sendNotification(title: "Average " + statInfoObject.displayName + " is trending high.", subtitle: "Tap to check your data within the app")
                    notificationSetting!.timeLastSent = Date()
                    setNotificationInUserDefaults(setting: notificationSetting!)
                }
            } else {
                if TimeFrameData.prevAverage[stat]! < notificationSetting!.value {
                    sendNotification(title: "Average " + statInfoObject.displayName + " is trending low.", subtitle: "Tap to check your data within the app")
                    notificationSetting!.timeLastSent = Date()
                    setNotificationInUserDefaults(setting: notificationSetting!)
                }
            }
        }
    }
}
func updateNotificationDataAndSend(with data: String, for stat: String){
    let statIndice = TimeFrameData.stats.firstIndex(where: {$0.name == stat})
    if statIndice != nil {
        let value = stringToDouble(string: data)
        let notificationSetting = getNotificationSetting(for: stat)
        if notificationSetting != nil && notificationSetting!.usesAverage{
            var mutableAverage = TimeFrameData.prevAverage[stat]!
            var mutableCount = Double(TimeFrameData.timesCollected[stat]!)
            TimeFrameData.hasCollected[stat] = true
            movingAverage(previousAverage: &mutableAverage, count: &mutableCount, newValue: value)
            TimeFrameData.prevAverage[stat] = mutableAverage
            TimeFrameData.timesCollected[stat] = Int(mutableCount)
        }
    }
}
func sendNotification(title: String, subtitle: String, sound: UNNotificationSound = UNNotificationSound.default){
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.sound = sound
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    print("NOTIFICATIONS::Added notification with title: \(title) and subtitle: \(subtitle) to queue")
    UNUserNotificationCenter.current().add(request)
}
func getNotificationSetting(for stat: String) -> NotificationSetting? {
    let key = stat  + "_NOTIFICATION_SETTING"
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    do {
        let setting = defaults.object(forKey: key)
        if setting != nil {
            let notificationSetting = try decoder.decode(NotificationSetting.self, from: setting as! Data)
            return notificationSetting
        }
        return nil
    } catch {
        print("NOTIFICATIONS::Could not decode or no setting is placed, exiting and returning false")
        return nil
    }
}
func checkAndSendNotification(stat: String, value: Double){
    var notificationSetting = getNotificationSetting(for: stat)
    if notificationSetting == nil  {
        return
    }
    var titlePrefix = ""
    let statName = getStatInfoObject(named: stat)!.displayName
    let subtitle = "Tap to check on your " + statName
    //if the notification is on
    if notificationSetting!.on && !notificationSetting!.usesAverage && Date().timeIntervalSince1970 - notificationSetting!.timeLastSent.timeIntervalSince1970 > TimeInterval(getNumSeconds(in: .hour)){
        //if its above
        if notificationSetting!.above{
            titlePrefix = "High "
            if value > notificationSetting!.value {
                //Its above the level return true
                sendNotification(title: titlePrefix + statName, subtitle: subtitle)
                notificationSetting!.timeLastSent = Date()
                setNotificationInUserDefaults(setting: notificationSetting!)
            } else  {
                //its below return
               return
            }
        //its below
        } else {
            //if its less than
            titlePrefix = "Low "
            if value <  notificationSetting!.value {
                //return true
                sendNotification(title: titlePrefix + statName, subtitle: subtitle)
                notificationSetting!.timeLastSent = Date()
                setNotificationInUserDefaults(setting: notificationSetting!)
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
func setBGtasks(){
    for stat in [HeartRate.shared, SPO2.shared, DiastolicPressure.shared, SystolicPressure.shared] as [Stat]{
        let notificationSetting = getNotificationSetting(for: stat.name)
        if notificationSetting != nil && notificationSetting!.usesAverage {
            let request = BGAppRefreshTaskRequest(identifier: "com.apollo.sendNotification." + stat.name)
            request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(notificationSetting!.averageTimeFrame))
            do {
                try BGTaskScheduler.shared.submit(request)
                print("NOTIFICATIONS::Scheduled notifications for \(stat.name)")
               } catch {
                print("NOTIFICATIONS::Could not schedule app refresh: \(error)")
               }
        } else {
            continue
        }
    }
}

func registerBGTasks() {
    print("NOTIFICATIONS::Registering bg tasks")
    let stats: [Stat] = [HeartRate.shared, SPO2.shared, SystolicPressure.shared, DiastolicPressure.shared]
    for stat in stats {
        let taskIdentifier = "com.apollo.sendNotification." + stat.name
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            handleNotificationRefresh(stat: stat.name)
        }
    }
}

func getTimeFrameFromSeconds(numSeconds: Int) -> Calendar.Component {
    switch numSeconds{
    case 1: return .second
    case 60: return .minute
    case 3600: return .hour
    case 86400: return .day
    case 604800: return .weekOfYear
    default: assert(false); return .year
    }
}
