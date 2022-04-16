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
    
    private func todayText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: persistentStore.trends.data[persistentStore.currentDay()].date)
    }
    
    private func formatTime(seconds: Int) -> Int {
        return seconds / 60
    }
    
    var body: some View {
        NavigationView {
            
            VStack() {
                
                Picker("Trends View", selection: $trendsView) {
                    Text("Day").tag(TrendsOptions.day)
                    Text("Week").tag(TrendsOptions.week)
                    Text("Month").tag(TrendsOptions.month)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Text("\(todayText())")
                    .font(.system(size: 25, weight: .medium))
                
                VStack(alignment: .leading) {
                    List {
                        Section(header: Text("Work Sessions").font(.headline).foregroundColor(.primary)) {
                            
                            HStack {
                                Text("Started")
                                Spacer()
                                Text("\(persistentStore.trends.data[persistentStore.currentDay()].startedSesssions)")
                            }
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(persistentStore.trends.data[persistentStore.currentDay()].completedSessions)")
                            }
                            
                            HStack {
                                Text("Total Work Time")
                                Spacer()
                                Text("\(formatTime(seconds: persistentStore.trends.data[persistentStore.currentDay()].totalSessionTime)) min")
                            }
                        }
                        
                        Section(header: Text("Breaks").font(.headline).foregroundColor(.primary)) {
                            HStack {
                                Text("Started")
                                Spacer()
                                Text("\(persistentStore.trends.data[persistentStore.currentDay()].startedBreaks)")
                            }
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(persistentStore.trends.data[persistentStore.currentDay()].completedBreaks)")
                            }
                            
                            HStack {
                                Text("Total Break Time")
                                Spacer()
                                Text("\(formatTime(seconds: persistentStore.trends.data[persistentStore.currentDay()].totalBreakTime)) min")
                            }
                        }
                    }.listStyle(.plain)
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

struct Trends_Previews: PreviewProvider {
    
    static var previews: some View {
        Trends()
            .environmentObject(PersistenceStore())
    }
}
