//
//  PulsePressure.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/12/22.
//

import Foundation

func getPulsePressure(sysData: [(Double, Date)], diaData: [(Double, Date)]) -> [(Double, Date)]{
    var pulsePressureData: [(Double, Date)] = []
    for indice in 0..<min(sysData.count, diaData.count){
        pulsePressureData.append((sysData[indice].0 - diaData[indice].0, sysData[indice].1))
    }
    return pulsePressureData
}
