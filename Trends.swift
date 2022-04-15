//
//  Trends.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import SwiftUI

enum TrendsOptions: CaseIterable {
    case day, week, month
}

struct Trends: View {
    
    // MARK: Environment
    @EnvironmentObject var persistentStore: PersistenceStore
    @EnvironmentObject var timer: ActiveTimer
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var trendsView: TrendsOptions = .day
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Picker("Trends View", selection: $trendsView) {
                    Text("Day").tag(TrendsOptions.day)
                    Text("Week").tag(TrendsOptions.week)
                    Text("Month").tag(TrendsOptions.month)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ForEach(persistentStore.trends.data, id: \.id) { data in
                    Text("\(data.date.description)")
                    Text("Completed Sessions: \(data.completedSessions)")
                    Text("Started Sessions: \(data.startedSesssions)")
                    Text("Total Session Time: \(data.totalSessionTime)")
                    Text("Completed Breaks: \(data.completedBreaks)")
                    Text("Started Breaks: \(data.startedBreaks)")
                    Text("Total Break Time: \(data.totalBreakTime)")
                }
                
                Spacer()
                
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
