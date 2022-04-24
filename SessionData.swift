//
//  SessionData.swift
//  Concentrate
//
//  Created by Sam Burkhard on 4/15/22.
//

import Foundation

struct SessionLog: Codable, Identifiable {
    
    var id: UUID
    var date: Date
    
    var completed: Bool
    
    var type: SessionType
    var length: Int // seconds
    
}

struct SessionData {
    
    var logs: [SessionLog]
        
    // Sessions
    var completedSessions: Int
    var startedSesssions: Int
    var totalSessionTime: Int // seconds
    
    // Breaks
    var completedBreaks: Int
    var startedBreaks: Int
    var totalBreakTime: Int // sessions
    
}
