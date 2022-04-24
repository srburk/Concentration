//
//  Settings.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import SwiftUI

struct Settings: View {
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var edited: Bool = false
            
    @State var workLength: Int = 0
    @State var shortLength: Int = 0
    @State var longLength: Int = 0
    @State var showingAlert: Bool = false
    
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    
    private func convertToSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
    
    private var timerAmounts: some View {
        List {
            Section(header: Text("Work Session")) {
                TextField("Work Session", value: $workLength, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                }.onChange(of: workLength) { _ in
                    persistentStore.session.workLength = convertToSeconds(minutes: workLength)
                }
                        
                Section(header: Text("Short Break")) {
                    TextField("Short Break", value: $shortLength, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }.onChange(of: shortLength) { _ in
                    persistentStore.session.shortLength = convertToSeconds(minutes: shortLength)
                }
                
                Section(header: Text("Long Break")) {
                    TextField("Long Break", value: $longLength, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }.onChange(of: longLength) { _ in
                    persistentStore.session.longLength = convertToSeconds(minutes: longLength)
                }
        }
        .navigationTitle("Timer Amounts")
        .navigationBarTitleDisplayMode(.inline)
    }
        
    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: timerAmounts) {
                        Label("Timer Amounts", systemImage: "timer").foregroundColor(.primary)
                    }
                    
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap").foregroundColor(.primary)
                    }
                                        
                }
                
                Button(action: {
                    showingAlert = true
                }) {
                    Text("Delete Session Data").foregroundColor(.red)
                }
            }
            
            .onAppear {
                workLength = persistentStore.session.workLength / 60
                shortLength = persistentStore.session.shortLength / 60
                longLength = persistentStore.session.longLength / 60
            }
            
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Delete All Session Data?"), message: Text("This will permanently remove your session history"), primaryButton: .default(
                    Text("Cancel"), action: { showingAlert = false }
                ), secondaryButton: .destructive(
                    Text("Delete"), action: { persistentStore.data = [] }
                ))
            }
            
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done").foregroundColor(.primary)
                    }
                }
            }
        }
        
    }
}

struct Settings_Previews: PreviewProvider {
    
    static var previews: some View {
        Settings()
            .environmentObject(PersistenceStore())
    }
}
