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
    
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    
    @ViewBuilder
    func rootView() -> some View {
        if (timer.isActive) {
            
            Image(systemName: "pause.fill")
                .font(.system(size: 75, weight: .medium))
                .onTapGesture {
                                            
                    withAnimation(.spring()) {
                        timer.stop()
                    }
                    
                    if (hapticFeedbackEnabled) {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }
                    
                }
            
                .transition(.scale)
                        
        } else {
            pausedControls
                .transition(.scale)
        }
    }
    
    var body: some View {
                    
        rootView()
            .frame(height: 100)
        
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Restart this session?"), message: Text("This will reset the timer"),
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
                    persistentStore.logSession(completed: false)
                    
                }
                                       
                if (hapticFeedbackEnabled) {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }
                
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 75, weight: .medium))
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
            }
            
        }
        .tint(.primary)
    }
    
}
