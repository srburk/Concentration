import SwiftUI

struct ContentView: View {
    
    // MARK: State Modals
    @State var isShowingTrends: Bool = false
    @State var isShowingSettings: Bool = false
    
    @State var nextSessionLabel: String = "Concentration"
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    
    func notificationText() -> String {
        switch(persistentStore.settings.activeSession) {
        case .work:
            return "Work session is up. Time for a break!"
        case .shortBreak:
            return "Short break is up. Back to work!"
        case .longBreak:
            return "Long break is up. Let's start working!"
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()

                SessionInfo()
                    .padding()
                
                Spacer()
                
                SessionControls()
                    .padding(.bottom, 110)
            }
            
            .onChange(of: timer.timeElapsed) { _ in
                if (timer.timeElapsed >= persistentStore.activeSessionLength()) {
                    timer.stop()
                    persistentStore.nextSession()
                    timer.timeElapsed = 0
                }
            }
            
            .onChange(of: scenePhase) { phase in
                persistentStore.save()
                
                if (timer.isActive) {
                    if (phase == .active) {
                        NotificationManager.shared.cancelAllNotifications()
                    } else if (phase == .background) {
                        let date = Date().addingTimeInterval(Double(persistentStore.activeSessionLength() - timer.timeElapsed))
                        
                        NotificationManager.shared.scheduleNotification(dateInterval: date, notificationString: notificationText())
                        
                        NotificationManager.shared.scheduleIndicatorNotification(notificationString: persistentStore.nextSessionName())
                    }
                }
            }
            
            .onChange(of: timer.isActive) { _ in
                if (!timer.isActive) {
                    withAnimation {
                        nextSessionLabel = "Concentration"
                    }
                } else {
                    withAnimation() {
                        nextSessionLabel = persistentStore.nextSessionName()
                    }
                }
            }
            
            .onAppear {
                if (needsOnboarding) {
                    NotificationManager.shared.requestAuth()
                    needsOnboarding.toggle()
                }
                
                persistentStore.load()
            }
            
            .navigationTitle(nextSessionLabel)
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: Modals
            .fullScreenCover(isPresented: $isShowingTrends) {
                Trends()
            }
            
            .sheet(isPresented: $isShowingSettings) {
                Settings()
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingSettings.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                    }.tint(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingTrends.toggle()
                    }) {
                        Image(systemName: "chart.bar.fill")
                    }.tint(.primary)
                }
            }
        }
    }
}
