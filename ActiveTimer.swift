//
//  Timer.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import Foundation
import Combine
import SwiftUI

class ActiveTimer: ObservableObject {
    
    static let shared = ActiveTimer()
    
    @Published var isActive: Bool = false
    
    @Published var timeElapsed: Int = 0
    @Published var timeCompensate: Int = 0
    
    private var startTime: Date?
    
    private var timer: AnyCancellable?
    
}

extension ActiveTimer {
    
    func finishTime(timeTarget: Int) -> String {
        if (self.isActive) {
            let now = Date()
            let finishDate = now.advanced(by: TimeInterval(timeTarget) - Double(timeElapsed))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: finishDate)
        } else {
            return ""
        }
    }
    
    func startTimer(timeTarget: Int) {
                
        if (isActive) {
            timer?.cancel()
            
            if (startTime == nil) {
                startTime = Date()
            }
            
            self.timeCompensate = timeElapsed
            
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    let now = Date()
                    let elapsed = now.timeIntervalSince(self.startTime!)
                    self.timeElapsed = Int(elapsed) + self.timeCompensate
                }
            
            self.isActive = true
        }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
        startTime = nil
        isActive = false
    }
    
}
