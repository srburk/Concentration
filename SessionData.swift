//
//  SessionData.swift
//  Concentration
//
//  Created by Sam Burkhard on 4/15/22.
//

import Foundation

struct SessionData: Codable {
    
    var data: [DailySessionData]
    
}

struct SessionLog: Codable, Identifiable {
    
    var id: UUID
    var date: Date
    
    var type: SessionType
    var length: Int // seconds
    
}

struct DailySessionData: Codable, Identifiable {
    
    var id: UUID
    
    // Sessions
    var completedSessions: Int
    var startedSesssions: Int
    var totalSessionTime: Int // seconds
    
    // Breaks
    var completedBreaks: Int
    var startedBreaks: Int
    var totalBreakTime: Int // sessions
    
    var date: Date
    
}
