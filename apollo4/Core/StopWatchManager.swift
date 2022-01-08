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
    }
    var totalTime : Double
    @Published var mode: stopWatchMode = .stopped
    @Published var secondsElapsed = 0.0
    @Published var progress = 0.0
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed + 0.1
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
