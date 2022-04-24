//
//  File.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import Foundation
import SwiftUI

enum SessionType: Codable, CaseIterable {
    case shortBreak, longBreak, work
}

struct SettingsModel: Codable {
    
    var activeSession: SessionType
    var completedSessions: Int
    var numWorkSessions: Int
    
}

struct SessionModel: Codable {
    
    var workLength: Int
    var shortLength: Int
    var longLength: Int
    
}

class PersistenceStore: ObservableObject {
    
    static let shared = PersistenceStore()
    
    @Published var settings: SettingsModel = SettingsModel(activeSession: .work, completedSessions: 0, numWorkSessions: 4)
    
    @Published var session: SessionModel = SessionModel(workLength: 1500, shortLength: 300, longLength: 1200)
    
//    @Published var trends: SessionData = SessionData(data: [])
    
    @Published var data: [SessionLog] = []
    
}

extension PersistenceStore {
    
    func logSession(completed: Bool) {
        let newSession = SessionLog(id: UUID(), date: Date(), completed: completed, type: settings.activeSession, length: activeSessionLength())
        data.append(newSession)
    }
    
    func dataReport(range: DateInterval) -> SessionData {
        let filteredData = data.filter {
            ($0.date >= range.start) && ($0.date <= range.end)
        }
        
        var completedSessions: Int = 0
        var startedSesssions: Int = 0
        var totalSessionTime: Int = 0// seconds
        
        var completedBreaks: Int = 0
        var startedBreaks: Int = 0
        var totalBreakTime: Int = 0 // sessions
        
        for log in filteredData {
            if (log.completed) {
                if (log.type == .work) {
                    completedSessions += 1
                    startedSesssions += 1
                    totalSessionTime += log.length
                } else {
                    completedBreaks += 1
                    startedBreaks += 1
                    totalBreakTime += log.length
                }
            } else {
                if (log.type == .work) {
                    startedSesssions += 1
                } else {
                    startedBreaks += 1
                }
            }
        }
        
        let session = SessionData(logs: filteredData, completedSessions: completedSessions, startedSesssions: startedSesssions, totalSessionTime: totalSessionTime, completedBreaks: completedBreaks, startedBreaks: startedBreaks, totalBreakTime: totalBreakTime)
        return session
        
    }
    
    func activeSessionLength() -> Int {
        switch (settings.activeSession) {
        case .work:
            return session.workLength
        case .shortBreak:
            return session.shortLength
        case .longBreak:
            return session.longLength
        }
    }
    
    func saveDemoData() {
        var demoData: [SessionLog] = []
        var sessionType: SessionType = .work
        var sessionLength: Int = 0
        for i in 0...7 {
            let day = Date().addingTimeInterval(TimeInterval(-i * 86400))
            for _ in 0...15 {
                let sessionTime = day.addingTimeInterval(TimeInterval(Double.random(in: -12.0...12.0) * 3600))
                
                switch(Int.random(in: 1...3)) {
                case 1:
                    sessionType = .work
                    sessionLength = session.workLength
                case 2:
                    sessionType = .shortBreak
                    sessionLength = session.shortLength
                case 3:
                    sessionType = (Bool.random()) ? .work : .longBreak
                    if (sessionType == .work) {
                        sessionLength = session.workLength
                    } else {
                        sessionLength = session.longLength
                    }
                default:
                    print("Error")
                }
                demoData.append(SessionLog(id: UUID(), date: sessionTime, completed: Bool.random(), type: sessionType, length: sessionLength))
            }
        }
        self.data = demoData
        self.save()
    }
    
    func nextSessionName() -> String {
        
        let finishTime = ActiveTimer.shared.finishTime(timeTarget: self.activeSessionLength())
        
        switch(settings.activeSession) {
        case .work:
            if (settings.completedSessions == settings.numWorkSessions) {
                return "Long break at \(finishTime)"
            } else {
                return "Short break at \(finishTime)"
            }
            
        case .shortBreak:
            return "Work session at \(finishTime)"
        case .longBreak:
            return "Work session at \(finishTime)"
        }
    }
    
    func nextSession() {
        
        withAnimation {
            switch(settings.activeSession) {
            case .work:
                
                settings.completedSessions += 1
                
                if (settings.completedSessions == settings.numWorkSessions) {
                    settings.activeSession = .longBreak
                } else {
                    settings.activeSession = .shortBreak
                }
                
            case .shortBreak:
                settings.activeSession = .work
            case .longBreak:
                settings.completedSessions = 0
                settings.activeSession = .work
            }
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(settings) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Settings")
        }
        
        if let encoded = try? encoder.encode(session) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Session")
        }
        
//        if let encoded = try? encoder.encode(trends) {
//            let defaults = UserDefaults.standard
//            defaults.set(encoded, forKey: "Trends")
//        }
        
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Data")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let settings = defaults.object(forKey: "Settings") as? Data {
            let decoder = JSONDecoder()
            if let settingsModel = try? decoder.decode(SettingsModel.self, from: settings) {
                self.settings = settingsModel
            }
        }
        
        if let session = defaults.object(forKey: "Session") as? Data {
            let decoder = JSONDecoder()
            if let sessionModel = try? decoder.decode(SessionModel.self, from: session) {
                self.session = sessionModel
            }
        }
        
//        if let trends = defaults.object(forKey: "Trends") as? Data {
//            let decoder = JSONDecoder()
//            if let sessionData = try? decoder.decode(SessionData.self, from: trends) {
//                self.trends = sessionData
//            }
//        }
        
        if let data = defaults.object(forKey: "Data") as? Data {
            let decoder = JSONDecoder()
            if let sessionData = try? decoder.decode([SessionLog].self, from: data) {
                self.data = sessionData
            }
        }
    }
    
}
