//
//  VO2Max.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/14/22.
//

import Foundation

func getVO2Max(hrData: [(Double, Date)]) -> Double {
    //Nil coalesing is temp. In the future if the user does not have a set of adequate hr data we will do the run test
    return 15 * ((hrData.map{$0.0}.max() ?? 140)/averageData(data: getRestingHR(hrData: hrData).map{$0.0}))
}
