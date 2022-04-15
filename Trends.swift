//
//  Trends.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import SwiftUI

struct Trends: View {
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Text("Wow you did so well")
            }
            
            .navigationTitle("Trends")
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
