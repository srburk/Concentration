//
//  SessionInfo.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import SwiftUI

struct SessionInfo: View {
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    private func formatTime(seconds: Int) -> String {
        
        let time = persistentStore.activeSessionLength() - seconds
        
        return "\(time / 60):\((time % 60 < 10) ? "0" : "")\(time % 60)"
    }
    
    private func completedSessionLabel() -> some View {
        
        return HStack(spacing: 8) {
            ForEach(0..<persistentStore.settings.numWorkSessions) { session in
                if (session < persistentStore.settings.completedSessions) {
                    Image(systemName: "circle.fill")
                        .foregroundColor(Color.softGreen)
                        .font(.system(size: 24, weight: .semibold))
                } else if (session == persistentStore.settings.completedSessions && persistentStore.settings.activeSession == .work) {
                    Image(systemName: "circle.lefthalf.filled")
                        .foregroundColor(Color.softGreen)
                        .font(.system(size: 24, weight: .semibold))
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(Color.softGreen)
                        .font(.system(size: 24, weight: .semibold))
                }
            }
        }
        
    }
    
    private func sessionLabel() -> some View {
        
        var color: Color = .white
        var nameColor: Color = .white
        var name: String = ""
        
        switch(persistentStore.settings.activeSession) {
        case .work:
            color = Color.softGray
            name = "Work Session"
            nameColor = .black
        case .shortBreak:
            color = Color.softGreen
            name = "Short Break"
            nameColor = .white
        case .longBreak:
            color = Color.softGreen
            name = "Long Break"
            nameColor = .white
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(color)
            
            Text(name)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(nameColor)
        }
        .frame(width: 200, height: 35)
        
    }
    
    var body: some View {
        VStack(spacing: 10) {
            
            completedSessionLabel()
            
            Text(formatTime(seconds: timer.timeElapsed))
                .font(.system(size: 100, weight: .medium))
            
                .overlay(sessionLabel().padding(.top, 160))
                        
        }
    }
}
