//
//  HyperTensionStructs.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/5/21.
//

import Foundation

struct HypertensionStruct {
    static let descriptionDict = [
        "Optimal" : "A lower than normal blood pressure level is less than 120/80 mmHg. Keep maintaining the healthy lifestyle you are pursuing.",
        "Normal"  : "A blood pressure level lower than 130/84 mmHg. Various factors that can raise blood pressure are habits such as smoking or unhealthy eating. Stress can also be a contributer. Genetic factors such as age, gender, and family history are also important.",
        "High Normal" : "A blood pressure level lower than 139/89 mmHg. This level puts a slight strain or your heart, putting you at risk for heart palpitations, shortness of breath, and general weakness. A healthy lifestyle can help bring down this strain, however its never a bad idea to talk to your doctor about medication.",
        "Grade 1 Hypertension" : "A blood pressure level lower than 159/99 mmHg. At this level there is a risk for cardiovascular disease and strain, such as heart disease or heart attack. Exercise and healthy eating can bring this strain down, but it's best to talk to your doctor if you have not.",
        "Grade 2 Hypertension" : "A blood pressure level lower than 179/109 mmHg. At this level there is a risk for cardiovascular disease and strain, such as heart disease or heart attack. Exercise and healthy eating can bring this strain down, but it's best to talk to your doctor if you have not.",
        "Grade 3 Hypertension" : "A blood pressure level higher than 180/110 mmHg. At this level there is a risk for cardiovascular disease and strain, such as heart disease or heart attack. Exercise and healthy eating can bring this strain down, but it's best to talk to your doctor if you have not."
    ]
    static let rangeDict = [
        "Optimal" : [[90, 120], [50, 80]],
        "Normal"  : [[121, 130], [81, 84]],
        "High Normal" : [[131, 139], [85, 89]],
        "Grade 1 Hypertension" : [[140, 159], [90, 99]],
        "Grade 2 Hypertension" : [[160, 179], [100, 109]],
        "Grade 3 Hypertension" : [[180, 200], [110, 130]]
    ]
}
func getBPLabel(systolicReading: Double, diastolicReading: Double) -> (String, String){
    var systolicLabel = "Optimal"
    var diastolicLabel = "Optimal"
    switch systolicReading {
    case 121..<131: systolicLabel = "Normal"
    case 131..<140: systolicLabel = "High Normal"
    case 140..<160: systolicLabel = "Grade 1 Hypertension"
    case 160..<180: systolicLabel = "Grade 2 Hypertension"
    case 180..<1000: systolicLabel = "Grade 3 Hypertension"
    default: break
    }
    switch diastolicReading {
    case 81..<85: diastolicLabel = "Normal"
    case 85..<90: diastolicLabel = "High Normal"
    case 90..<100: diastolicLabel = "Grade 1 Hypertension"
    case 100..<110: diastolicLabel = "Grade 2 Hypertension"
    case 110..<1000: diastolicLabel = "Grade 3 Hypertension"
    default: break
    }
    return (systolicLabel, diastolicLabel)
}
