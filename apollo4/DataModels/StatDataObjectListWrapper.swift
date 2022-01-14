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
        print("Initializing stat wrapper")
        stats = fetchStatDataObjects()
    }
    func update(){
        print("Updating stat wrapper")
        stats = fetchStatDataObjects()
    }
}
