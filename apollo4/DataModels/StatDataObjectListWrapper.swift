//
//  StatDataObjectListWrapper.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/7/22.
//

import Foundation

class StatDataObjectListWrapper : ObservableObject {
    var stats: [StatDataObject]
    init(){
        stats = fetchStatDataObjects()
    }
    func update(){
        stats = fetchStatDataObjects()
    }
}
