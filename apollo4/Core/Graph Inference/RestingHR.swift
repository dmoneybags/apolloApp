//
//  RestingHR.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/12/22.
//

import Foundation

func getRestingHR(hrData: [(Double, Date)]) -> [(Double, Date)]{
    return hrData.filter {$0.0 < 95}
}
