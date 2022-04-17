//
//  ChartView.swift
//  Concentration
//
//  Created by Sam Burkhard on 4/16/22.
//

import SwiftUI

struct ChartView: View {
    
    var sessions: [SessionLog]
    @Binding var trendsView: TrendsOptions
    
    var weekdays: [String] = ["S", "M", "T", "W", "T", "F", "S"]
        
    private func maxSessions() -> Int {
        
        var maxSession: Int = 0
        
        for number in 0..<12 {
            let filteredSessions = sessions.filter {
                $0.date >= Calendar.current.date(bySettingHour: number * 2, minute: 0, second: 0, of: $0.date)! && $0.date <= Calendar.current.date(bySettingHour: (number * 2) + 1, minute: 0, second: 0, of: $0.date)! && $0.type == .work && $0.completed
            }
            
            if filteredSessions.count > maxSession {
                maxSession = filteredSessions.count
            }
        }
        
        return (maxSession == 0) ? 1 : maxSession
    }
    
    private func WeekBarSection(number: Int) -> some View {
        
        let filteredSessions = sessions.filter {
            $0.date >= Calendar.current.date(bySettingHour: number, minute: 0, second: 0, of: $0.date)! && $0.date <= Calendar.current.date(bySettingHour: number + 1, minute: 0, second: 0, of: $0.date)! && $0.type == .work && $0.completed
        }
        
        let barHeight = filteredSessions.count * (120 / maxSessions())
        
        return VStack {
            
            if (barHeight == 0) {
                RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 120)
                    .foregroundColor(.softGray)
            } else {
                RoundedRectangle(cornerRadius: 10).frame(width: 35, height: CGFloat(barHeight))
                    .foregroundColor(.softGreen)
            }
            
            Text("\(weekdays[number])").font(.system(size: 12))
        }
        
    }
    
    private func DayBarSection(number: Int) -> some View {

        let filteredSessions = sessions.filter {
            $0.date >= Calendar.current.date(bySettingHour: number, minute: 0, second: 0, of: $0.date)! && $0.date <= Calendar.current.date(bySettingHour: number + 1, minute: 0, second: 0, of: $0.date)! && $0.type == .work && $0.completed
        }
        
        let barHeight = filteredSessions.count * (120 / maxSessions())
        
        return VStack {
            
            if (barHeight == 0) {
                RoundedRectangle(cornerRadius: 10).frame(width: 12, height: 120)
                    .foregroundColor(.softGray)
            } else {
                RoundedRectangle(cornerRadius: 10).frame(width: 12, height: CGFloat(barHeight))
                    .foregroundColor(.softGreen)
            }
            
            Text("\(number)").font(.system(size: 12))
        }
    }
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .bottom, spacing: 15) {
                
                VStack(spacing: 35) {
                    Text("4").font(.system(size: 12))
                    Text("2").font(.system(size: 12))
                    Text("0").font(.system(size: 12))
                    Spacer()
                }.frame(height: 120)
                
                switch (trendsView) {
                case .day:
                    ForEach(0..<12) { number in
                        DayBarSection(number: number * 2)
                    }
                case .week:
                    ForEach(0..<7) { number in
                        WeekBarSection(number: number)
                    }
                case .month:
                    ForEach(0..<12) { number in
                        DayBarSection(number: number * 2)
                    }
                }
                
            }
            
        }
        .frame(height: 125)
        .padding(.top, 15)
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(sessions: [SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200), SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200)], trendsView: .constant(.day))
    }
}
