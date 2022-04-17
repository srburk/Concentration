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
    
    private var timerAmounts: some View {
        List {
            Section(header: Text("Work Session")) {
                TextField("Work Session", value: $persistentStore.session.workLength, formatter: NumberFormatter())
            }
            Section(header: Text("Short Break")) {
                TextField("Short Break", value: $persistentStore.session.shortLength, formatter: NumberFormatter())
            }
            Section(header: Text("Long Break")) {
                TextField("Long Break", value: $persistentStore.session.longLength, formatter: NumberFormatter())
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
                    
                    NavigationLink(destination: timerAmounts) {
                        Label("Notifications", systemImage: "bell").foregroundColor(.primary)
                    }
                    
                    NavigationLink(destination: Text("Color Accent")) {
                        Label("Color Accent", systemImage: "paintpalette").foregroundColor(.primary)
                    }
                    
                }
                
                Button(action: {
                    print("DELETE")
                }) {
                    Text("Delete Session Data").foregroundColor(.red)
                }
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
