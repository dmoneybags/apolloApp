//
//  Inference.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/24/21.
//

import Foundation
import SwiftUI
func getProgres(stat: String, reading: Double) -> Double{
    var maxVal: Double
    var minVal: Double
    var inverted = false
    switch stat {
        case "SPO2":
            maxVal = 100
            minVal = 95
            inverted = true
        case "HeartRate":
            maxVal = 140
            minVal = 40
        case "SystolicPressure":
            maxVal = 110
            minVal = 50
        case "DiastolicPressure":
            maxVal = 190
            minVal = 100
        default:
            maxVal = 200
            minVal = 100
    }
    return (reading - minVal)/(maxVal - minVal)
}
func getColor(stat: String, progress: Double) -> Color{
    var inverted = false
    var red: Int
    var green: Int
    let blue = 66
    if stat == "SPO2"{
        inverted = true
    }
    var colorPoints = Int(progress * 358)
    if inverted{
        red = 245
        green = 66
    } else {
        red = 66
        green = 245
    }
    for _ in 0..<179{
        if colorPoints <= 1{
            break
        }
        if inverted {
            green += 1
        } else {
            red += 1
        }
        colorPoints -= 1
    }
    for _ in 0..<179{
        if colorPoints <= 1{
            break
        }
        if inverted {
            red -= 1
        } else {
            green -= 1
        }
        colorPoints -= 1
    }
    
    return Color(UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0))
}
func getTimeComponent(date: Date, timeFrame: Calendar.Component) -> String{
    let calendar = Calendar.current
    let component = calendar.component(timeFrame, from: date)
    if timeFrame == .hour{
        var hour: Int = Int(component)
        let minutes: Int = Int(calendar.component(.minute, from: date))
        if hour > 12 {
            hour = hour % 12
            return String(hour) + ":" + String(format: "%02d", minutes) + " PM"
        } else if hour == 0 {
            return String(12) + ":" + String(format: "%02d", minutes) + " AM"
        } else {
            return String(hour) + ":" + String(format: "%02d", minutes) + " AM"
        }
    }
    let month: Int = Int(calendar.component(.month, from: date))
    let day: Int = Int(component)
    if timeFrame == .day{
        let hour: String = getTimeComponent(date: date, timeFrame: .hour)
        return String(month) + "/" + String(day) + ", " + hour
    }
    if timeFrame == .month{
        return String(month) + "/" + String(day)
    }
    return ""
}
func getTimeRangeVal(dates: [Date]) -> Calendar.Component {
    let calendar = Calendar.current
    let firstDay = calendar.component(.day, from: dates.first!)
    let lastDay = calendar.component(.day, from: dates.last!)
    if firstDay == lastDay {
        return .hour
    }
    let firstMonth = calendar.component(.month, from: dates.first!)
    let lastMonth = calendar.component(.month, from: dates.last!)
    if firstMonth == lastMonth {
        return .day
    }
    return .month
}
func filterData(data: [(Double, Date)], timeFrame: Calendar.Component, num: Int) -> [(Double, Date)]{
    let dateList = data.map{$0.1}
    let calendar = Calendar.current
    var minutes = calendar.component(timeFrame, from: dateList.first!)
    var filteredData: [(Double, Date)] = []
    for reading in data{
        let difference = calendar.component(timeFrame, from: reading.1) - minutes
        if difference > minutes || difference < 0{
            minutes = calendar.component(timeFrame, from: reading.1)
            filteredData.append(reading)
        }
    }
    print("Filtered data to \(filteredData)")
    return filteredData
}
