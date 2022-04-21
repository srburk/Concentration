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
    
    @State var dateSelection: Date = Date()
    @State var trendsView: TrendsOptions = .day
    @State var trendsData: SessionData = SessionData(logs: [], completedSessions: 0, startedSesssions: 0, totalSessionTime: 0, completedBreaks: 0, startedBreaks: 0, totalBreakTime: 0)
    
    private func formatTime(seconds: Int) -> Int {
            return seconds / 60
        }
    
    private func todayText() -> String {
        
        let dateFormatter = DateFormatter()
        
        var text: String = ""
        
        switch (trendsView) {
        case .day:
            dateFormatter.dateFormat = "MMMM d"
            text = dateFormatter.string(from: dateSelection)
        case .week:
            dateFormatter.dateFormat = "MMM d"
            let pastDay = Calendar.current.date(byAdding: .day, value: -7, to: dateSelection)
            text = dateFormatter.string(from: pastDay!) + "  –  " + dateFormatter.string(from: dateSelection)
        case .month:
            dateFormatter.dateFormat = "MMMM yyyy"
            text = dateFormatter.string(from: dateSelection)
        }
        return text
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
                    Button(action: {
                        withAnimation(.spring()) {
                            switch(trendsView) {
                            case .day:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(-1 * 86400))
                            case .week:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(-7 * 86400))
                            case .month:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(-7 * 86400))
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                    }.tint(.primary)
                    
                    Spacer()
                    
                    Text("\(todayText())")
                        .font(.system(size: 20, weight: .medium))
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            switch(trendsView) {
                            case .day:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(1 * 86400))
                            case .week:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(7 * 86400))
                            case .month:
                                dateSelection = dateSelection.addingTimeInterval(TimeInterval(7 * 86400))
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                    }.tint(.primary)
                    
                }.padding([.leading, .trailing], 35)
                
                ChartView(sessions: trendsData.logs, trendsView: $trendsView, dateSelection: $dateSelection)
                
                VStack(alignment: .leading) {
                    List {
                        Section(header: Text("Work Sessions").font(.headline).foregroundColor(.primary)) {
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(trendsData.completedSessions)")
                            }
                            
                            HStack {
                                Text("Completion Rate")
                                Spacer()
                                Text("\((trendsData.startedSesssions != 0) ? (String(format: "%.0f" ,(Double(trendsData.completedSessions) / Double(trendsData.startedSesssions)) * 100.0)) : "0")%")
                            }
                            
                            HStack {
                                Text("Total Work Time")
                                Spacer()
                                Text("\(formatTime(seconds: trendsData.totalSessionTime)) min")
                            }
                        }
                        
                        Section(header: Text("Breaks").font(.headline).foregroundColor(.primary)) {
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text("\(trendsData.completedBreaks)")
                            }
                            
                            HStack {
                                Text("Completion Rate")
                                Spacer()
                                Text("\((trendsData.startedBreaks != 0) ? (String(format: "%.0f" ,(Double(trendsData.completedBreaks) / Double(trendsData.startedBreaks)) * 100.0)) : "0")%")
                            }
                            
                            HStack {
                                Text("Total Break Time")
                                Spacer()
                                Text("\(formatTime(seconds: trendsData.totalBreakTime)) min")
                            }
                        }
                    }.listStyle(.plain)
                        .padding(.top, 25)
                }
                
                Spacer()
                
            }
            
            .onAppear {
                let dateInterval: DateInterval
                
                dateInterval = Calendar.current.dateInterval(of: .month, for: Date()) ?? DateInterval(start: Date(), end: Date())
                
                trendsData = persistentStore.dataReport(range: dateInterval)
            }
            
            .onChange(of: trendsView) { _ in
                
                let dateInterval: DateInterval
                
                dateInterval = Calendar.current.dateInterval(of: .month, for: Date()) ?? DateInterval(start: Date(), end: Date())
                
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
