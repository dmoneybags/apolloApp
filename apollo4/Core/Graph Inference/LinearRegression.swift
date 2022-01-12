//
//  LinearRegression.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/8/22.
//

import Foundation
//Calculates line of regression by inputting data and returning coefficients m (slope)
func calcLinearReg(data: [Double]) -> (Double, Double){
    var xValues: [Double] = []
    var i: Int = 0
    for _ in data {
        xValues.append(Double(i))
        i += 1
    }
    let xMean: Double = averageData(data: xValues)
    let yMean: Double = averageData(data: data)
    let n = data.count
    var numerator: Double = 0
    var denominator: Double = 0
    for j in 0..<n {
        numerator += (xValues[j] - xMean) * (data[j] - yMean)
        denominator += pow(xValues[j] - xMean, 2)
    }
    let m = numerator/denominator
    let b = yMean - (m * xMean)
    return (m, b)
}
