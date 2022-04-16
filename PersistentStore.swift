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
    
    @Published var trends: SessionData = SessionData(data: [])
    
}

extension PersistenceStore {
    
    private func makeNewData() {
        let newData = DailySessionData(id: UUID(), completedSessions: 0, startedSesssions: 0, totalSessionTime: 0, completedBreaks: 0, startedBreaks: 0, totalBreakTime: 0, date: Date())
        trends.data.append(newData)
    }
    
    func currentDay() -> Int {
        
        if (trends.data.isEmpty) {
            makeNewData()
        } else {
            if (Calendar.current.isDateInToday(trends.data.last!.date)) {
            } else {
                makeNewData()
            }
        }
        
        return trends.data.endIndex - 1
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
        
        if let encoded = try? encoder.encode(trends) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Trends")
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
        
        if let trends = defaults.object(forKey: "Trends") as? Data {
            let decoder = JSONDecoder()
            if let sessionData = try? decoder.decode(SessionData.self, from: trends) {
                self.trends = sessionData
            }
        }
    }
    
}
