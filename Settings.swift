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
    
    @State var usingDeveloperSettings: Bool = false
    
    var body: some View {
        
        NavigationView {
            List {
                Button(action: {
                    usingDeveloperSettings.toggle()
                }) {
                    Text("Toggle Developer Settings")
                }
            }
            
            .onChange(of: usingDeveloperSettings) { _ in
                if (usingDeveloperSettings) {
                    persistentStore.session.workLength = 25
                    persistentStore.session.shortLength = 5
                    persistentStore.session.longLength = 20
                } else {
                    persistentStore.session.workLength = 1500
                    persistentStore.session.shortLength = 300
                    persistentStore.session.longLength = 1200
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
