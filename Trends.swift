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
    @State var trendsData: SessionData = SessionData(logs: [], completedSessions: 0, startedSesssions: 0, totalSessionTime: 0, completedBreaks: 0, startedBreaks: 0, totalBreakTime: 0)
    
    private func todayText() -> String {
        
        let dateFormatter = DateFormatter()
        
        var text: String = ""
        
        switch (trendsView) {
        case .day:
            dateFormatter.dateFormat = "MMMM d"
            text = dateFormatter.string(from: Date())
        case .week:
            dateFormatter.dateFormat = "MMM d"
            let pastDay = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            text = dateFormatter.string(from: pastDay!) + "  –  " + dateFormatter.string(from: Date())
        case .month:
            dateFormatter.dateFormat = "MMMM yyyy"
            text = dateFormatter.string(from: Date())
        }
        return text
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
                
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                    Text("\(todayText())")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                }.padding([.leading, .trailing], 35)
                
                ChartView(sessions: trendsData.logs)
                
                VStack(alignment: .leading) {
                    List {
                        Section(header: Text("Work Sessions").font(.headline).foregroundColor(.primary)) {
                            
                            HStack {
                                Text("Started")
                                Spacer()
                                Text("\(trendsData.startedSesssions)")
                            }
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(trendsData.completedSessions)")
                            }
                            
                            HStack {
                                Text("Total Work Time")
                                Spacer()
                                Text("\(formatTime(seconds: trendsData.totalSessionTime)) min")
                            }
                        }
                        
                        Section(header: Text("Breaks").font(.headline).foregroundColor(.primary)) {
                            HStack {
                                Text("Started")
                                Spacer()
                                Text("\(trendsData.startedBreaks)")
                            }
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(trendsData.completedBreaks)")
                            }
                            
                            HStack {
                                Text("Total Break Time")
                                Spacer()
                                Text("\(formatTime(seconds: trendsData.totalBreakTime)) min")
                            }
                        }
                    }.listStyle(.plain)
                }
                
                Spacer()
                
            }
            
            .onAppear {
                
                let dateInterval: DateInterval
                
                switch(trendsView) {
                case .day:
                    dateInterval = Calendar.current.dateInterval(of: .day, for: Date()) ?? DateInterval(start: Date(), end: Date())
                case .week:
                    let pastDay = Calendar.current.date(byAdding: .day, value: -7, to: Date())
                    dateInterval = DateInterval(start: pastDay!, end: Date())
                case .month:
                    dateInterval = Calendar.current.dateInterval(of: .month, for: Date()) ?? DateInterval(start: Date(), end: Date())
                }
                
                trendsData = persistentStore.dataReport(range: dateInterval)

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
