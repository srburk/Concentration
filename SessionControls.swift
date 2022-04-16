//
//  File.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import Foundation
import SwiftUI

struct SessionControls: View {
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    @State var isShowingAlert: Bool = false
    
    @State var startedSession: Bool = false
    
    @ViewBuilder
    func rootView() -> some View {
        if (timer.isActive) {
            
            Image(systemName: "pause.fill")
                .font(.system(size: 75, weight: .medium))
                .shadow(radius: 1)
                .onTapGesture {
                                            
                    withAnimation(.spring()) {
                        timer.stop()
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }
            
                .transition(.scale)
                        
        } else {
            pausedControls
                .transition(.scale)
        }
    }
    
    var body: some View {
                    
        rootView()
        
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Restart this session?"),
                  primaryButton: .default(
                    Text("Cancel"),
                    action: { isShowingAlert = false }
                  ),
                  secondaryButton: .destructive(
                    Text("Reset"),
                    action: {
                        withAnimation(.spring()) {
                            timer.timeElapsed = 0
                            timer.stop()
                        }
                    }
                  ))
        }
        
        .onChange(of: persistentStore.settings.activeSession) { _ in
            startedSession = false
        }
            
    }
    
    private var pausedControls: some View {
        
        HStack(spacing: 35) {
            
            // Restart Timer
            Button(action: {
                
                isShowingAlert.toggle()
                
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 40, weight: .medium))
                    .shadow(radius: 1)
            }
            
            // Resume Timer
            Button(action: {
                
                withAnimation(.spring()) {
                    timer.isActive = true
                    timer.startTimer(timeTarget: persistentStore.activeSessionLength())
                }
                
                if (!startedSession) {
                    startedSession = true
                    // incremement started
                    switch(persistentStore.settings.activeSession) {
                    case .work:
                        persistentStore.trends.data[persistentStore.currentDay()].startedSesssions += 1
                    case .longBreak:
                        persistentStore.trends.data[persistentStore.currentDay()].startedBreaks += 1
                    case .shortBreak:
                        persistentStore.trends.data[persistentStore.currentDay()].startedBreaks += 1
                    }
                    
                }
                                                
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 75, weight: .medium))
                    .shadow(radius: 1)
            }
            
            // Skip Forward
            Button(action: {
                
                withAnimation(.spring()) {

                    timer.timeElapsed = 0
                    timer.isActive = true
                    persistentStore.nextSession()
                    timer.startTimer(timeTarget: persistentStore.activeSessionLength())
                }
                
            }) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 40, weight: .medium))
                    .shadow(radius: 1)
            }
            
        }
        .tint(.primary)
    }
    
}
