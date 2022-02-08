//
//  StatDataObjectListWrapper.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/7/22.
//

import Foundation

typealias CompletionHandler = (_ success:Bool) -> Void

class StatDataObjectListWrapper : ObservableObject {
    static var stats: [StatDataObject] = fetchStatDataObjects()
    static func update(completionHandler: CompletionHandler){
        print("Updating stat wrapper")
        stats = fetchStatDataObjects()
        let flag = true
        completionHandler(flag)
    }
}
