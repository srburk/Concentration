//
//  ChartView.swift
//  Concentration
//
//  Created by Sam Burkhard on 4/16/22.
//

import SwiftUI

struct ChartView: View {
    
    var sessions: [SessionLog]
        
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
    
    private func BarSection(number: Int) -> some View {

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
                
                ForEach(0..<12) { number in
                    BarSection(number: number * 2)
                }
            }
            
        }
        .frame(height: 125)
        .padding(.top, 15)
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(sessions: [SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200), SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200)])
    }
}
