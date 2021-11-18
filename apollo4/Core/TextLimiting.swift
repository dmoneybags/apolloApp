//
//  TextLimiting.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import Foundation

class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    @Published var hasReachedLimit = false
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
}
