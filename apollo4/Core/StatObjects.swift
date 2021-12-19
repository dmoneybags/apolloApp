//
//  StatObjects.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/7/21.
//

import Foundation
import SwiftUI
protocol Stat {
    var name: String {get}
    var url: URL {get}
    var measurement: String {get}
    var minVal: Int {get}
    var maxVal: Int {get}
    func getLabel(reading: Double) -> String
    func getRange(label: String) -> (Double, Double)
    func getColor(forLabel label: String) -> Color 
    //func getDescription(label: String) -> String
    //func getGoal()
}
struct HeartRate: Stat {
    let name = "HeartRate"
    let url = getDocumentsDirectory().appendingPathComponent("HeartRate")
    let measurement = "BPM"
    let minVal = 40
    let maxVal = 220
    func getLabel(reading: Double) -> String {
        //Add age
        switch reading{
        case 0..<60: return "Optimal"
        case 60..<65: return "Excellent"
        case 65..<70: return "Great"
        case 70..<74: return "Good"
        case 74..<78: return "Average"
        case 78..<85: return "Below Average"
        default: return "Poor"
        }
    }
    func getRange(label: String) -> (Double, Double) {
        switch label{
        case "Optimal": return (40, 59)
        case "Excellent": return (60, 64)
        case "Great": return (65, 69)
        case "Good": return (70, 74)
        case "Average": return (75, 77)
        case "Below Average": return (78, 85)
        case "Poor" : return (86, 120)
        default: return (40, 120)
        }
    }
    func getColor(forLabel label: String) -> Color {
        switch label{
        case "Optimal": return Color.purple
        case "Excellent": return Color.blue
        case "Great": return Color.teal
        case "Good": return Color.green
        case "Average": return Color.yellow
        case "Below Average": return Color.orange
        case "Poor" : return Color.red
        default: return Color.red
        }
    }
}
struct SPO2: Stat{
    let name = "SPO2"
    let url = getDocumentsDirectory().appendingPathComponent("SPO2")
    let measurement = "%"
    let minVal = 85
    let maxVal = 100
    func getLabel(reading: Double) -> String {
        switch reading{
        case 0..<85: return "Critical"
        case 85..<90: return "Low"
        case 90..<95: return "Insufficient"
        case 95..<100: return "Optimal"
        default: return ""
        }
    }
    func getRange(label: String) -> (Double, Double) {
        switch label{
        case "Critcal": return (75, 84)
        case "Low": return (85, 89)
        case "Insufficent": return (90, 94)
        case "Optimal": return (95, 100)
        default: return (75, 100)
        }
    }
    func getColor(forLabel label: String) -> Color {
        switch label{
        case "Critcal": return Color.red
        case "Low": return Color.yellow
        case "Insufficent": return Color.green
        case "Optimal": return Color.purple
        default: return Color.red
        }
    }
}
struct SystolicPressure: Stat{
    let name = "SystolicPressure"
    let url = getDocumentsDirectory().appendingPathComponent("SystolicPressure")
    let measurement: String = "mmHg"
    let minVal = 100
    let maxVal = 200
    func getLabel(reading: Double) -> String {
        switch reading {
        case 100..<121: return "Optimal"
        case 121..<131: return "Normal"
        case 131..<140: return "High Normal"
        case 140..<160: return "Grade 1 Hypertension"
        case 160..<180: return "Grade 2 Hypertension"
        case 180..<1000: return "Grade 3 Hypertension"
        default: return ""
        }
    }
    func getRange(label: String) -> (Double, Double) {
        switch label {
        case "Optimal" : return (90, 120)
        case "Normal"  : return (121, 130)
        case "High Normal" : return (131, 139)
        case "Grade 1 Hypertension" : return (140, 159)
        case "Grade 2 Hypertension" : return (160, 179)
        case "Grade 3 Hypertension" : return (180, 200)
        default: return (90,200)
        }
    }
    func getColor(forLabel label: String) -> Color {
        switch label {
        case "Optimal" : return Color.purple
        case "Normal"  : return Color.blue
        case "High Normal" : return Color.green
        case "Grade 1 Hypertension" : return Color.yellow
        case "Grade 2 Hypertension" : return Color.orange
        case "Grade 3 Hypertension" : return Color.red
        default: return Color.red
        }
    }
}
struct DiastolicPressure: Stat{
    let name = "DiastolicPressure"
    let url = getDocumentsDirectory().appendingPathComponent("DiastolicPressure")
    let measurement: String = "mmHg"
    let minVal = 50
    let maxVal = 160
    func getLabel(reading: Double) -> String {
        switch reading {
        case 81..<85: return "Normal"
        case 85..<90: return "High Normal"
        case 90..<100: return "Grade 1 Hypertension"
        case 100..<110: return "Grade 2 Hypertension"
        case 110..<1000: return "Grade 3 Hypertension"
        default: return ""
        }
    }
    func getRange(label: String) -> (Double, Double) {
        switch label{
        case "Optimal" : return (50, 80)
        case "Normal"  : return (81, 84)
        case "High Normal" : return (85, 89)
        case "Grade 1 Hypertension" : return (90, 99)
        case "Grade 2 Hypertension" : return (100, 109)
        case "Grade 3 Hypertension" : return (110, 130)
        default: return (50,130)
        }
    }
    func getColor(forLabel label: String) -> Color {
        switch label {
        case "Optimal" : return Color.purple
        case "Normal"  : return Color.blue
        case "High Normal" : return Color.green
        case "Grade 1 Hypertension" : return Color.yellow
        case "Grade 2 Hypertension" : return Color.orange
        case "Grade 3 Hypertension" : return Color.red
        default: return Color.red
        }
    }
}
