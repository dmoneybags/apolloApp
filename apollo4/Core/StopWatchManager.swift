//
//  StopWatchManager.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/29/21.
//

import Foundation

import SwiftUI


enum stopWatchMode {
    case running
    case stopped
    case paused
}

class StopWatchManager: ObservableObject {
    init(timeLim: Double){
        self.totalTime = timeLim
        self.lastUpdated = Date()
    }
    var totalTime : Double
    @Published var mode: stopWatchMode = .stopped
    @Published var secondsElapsed = 0.0
    @Published var progress = 0.0
    private var lastUpdated: Date
    var timer = Timer()
    
    func start() {
        mode = .running
        self.lastUpdated = Date()
        print("Starting StopWatch at \(self.lastUpdated)")
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let currentAccumulatedTime: Double = Date().timeIntervalSince(self.lastUpdated)
            self.secondsElapsed = self.secondsElapsed + currentAccumulatedTime
            self.lastUpdated = Date()
            self.progress = self.secondsElapsed/self.totalTime
            if self.secondsElapsed >= self.totalTime{
                self.stop()
            }
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
    
}
