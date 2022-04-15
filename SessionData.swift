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
