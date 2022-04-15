//
//  TrendsManager.swift
//  Concentration
//
//  Created by Sam Burkhard on 4/15/22.
//

import Foundation

class TrendsManager {
    
    static let shared = TrendsManager()
    
    let persistentStore = PersistenceStore.shared
    
}

extension TrendsManager {
    
    private func makeNewData() {
        let newData = DailySessionData(id: UUID(), completedSessions: 0, startedSesssions: 0, totalSessionTime: 0, completedBreaks: 0, startedBreaks: 0, totalBreakTime: 0, date: Date())
        persistentStore.trends.data.append(newData)
    }
    
    func currentDay() -> Int {
        
        if (persistentStore.trends.data.isEmpty) {
            makeNewData()
        } else {
            if (Calendar.current.isDateInToday(persistentStore.trends.data.last!.date)) {
            } else {
                makeNewData()
            }
        }
        
        return persistentStore.trends.data.endIndex - 1
    }
    
}
