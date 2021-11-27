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
