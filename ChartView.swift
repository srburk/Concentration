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
    
    @Binding var dateSelection: Date
    
    @Environment(\.colorScheme) var colorScheme

    var weekdays: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    
    private func chartLines(label: String) -> some View {
        return VStack(spacing: 39) {
            
            ForEach(0..<4) { number in
                if number == 0 {
                    RoundedRectangle(cornerRadius: 10).frame(height: 1).foregroundColor((colorScheme == .light) ? Color(red: 218/255, green: 218/255, blue: 218/255) : Color(red: 35/255, green: 35/255, blue: 35/255))
                        .overlay(Text(label).font(.system(size: 12, weight: .medium )).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 25).foregroundColor(.softMint))
                } else {
                    RoundedRectangle(cornerRadius: 10).frame(height: 1).foregroundColor((colorScheme == .light) ? Color(red: 218/255, green: 218/255, blue: 218/255) : Color(red: 35/255, green: 35/255, blue: 35/255))
                }
            }
        }
        .padding(.leading, 15)
        .frame(height: 120, alignment: .top)
    }
    
    private func weekChart() -> some View {
        
        var maxSessions: Int = 0
        
        for number in 0..<7 {
            
            let filteredSessions = sessions.filter {
                Calendar.current.isDate($0.date, inSameDayAs: dateSelection.addingTimeInterval(TimeInterval((number-6) * 86400))) && $0.type == .work && $0.completed
            }
            
            print(filteredSessions.count)
            
            if filteredSessions.count > maxSessions {
                maxSessions = filteredSessions.count
            }
            
        }
        
        return VStack {
            
            ZStack {
                
                chartLines(label: "\(maxSessions) Sessions")
                
                HStack(alignment: .bottom, spacing: 15) {
                    
                    ForEach(0..<7) { number in
                            
                        let filteredSessions = sessions.filter {
                            Calendar.current.isDate($0.date, inSameDayAs: dateSelection.addingTimeInterval(TimeInterval((number-6) * 86400))) && $0.type == .work && $0.completed
                        }
                        
                        let barHeight = filteredSessions.count * (120 / ((maxSessions == 0) ? 1 : maxSessions))
                        
                        VStack {
                            if (barHeight == 0) {
                                RoundedRectangle(cornerRadius: 10).frame(width: 25, height: 120)
                                    .opacity(0.0)
                            } else {
                                Rectangle()
                                    .frame(width: 25, height: CGFloat(barHeight))
                                    .foregroundColor(.softMint)
                                    .cornerRadius(10, corners: [.topLeft, .topRight])
                            }
                            
                        }
                        .overlay(Text("\(weekdays[number])")
                            .font(.system(size: 12))
                            .padding(.top, 150)
                        )
                        
                    }
                }
            }
        }
    }
    
    
    private func dayChart() -> some View {
        
        var maxSessions: Int = 0
        
        for number in 0..<24 {
            
            let filteredSessions = sessions.filter {
                $0.date >= Calendar.current.date(bySettingHour: number, minute: 0, second: 0, of: dateSelection) ?? Date() && $0.date <= Calendar.current.date(bySettingHour: number + 1, minute: 0, second: 0, of: dateSelection) ?? Date() && $0.type == .work && $0.completed
            }
            
            if filteredSessions.count > maxSessions {
                maxSessions = filteredSessions.count
            }
            
        }
                
        return VStack {
            
            ZStack {
                
                chartLines(label: "\(maxSessions) Sessions")
                
                HStack(alignment: .bottom, spacing: 8) {
                    
                    ForEach(0..<24) { number in
                        
                        let filteredSessions = sessions.filter {
                            $0.date >= Calendar.current.date(bySettingHour: number, minute: 0, second: 0, of: dateSelection) ?? Date() && $0.date <= Calendar.current.date(bySettingHour: number + 1, minute: 0, second: 0, of: dateSelection) ?? Date() && $0.type == .work && $0.completed
                        }
                        
                        let barHeight = filteredSessions.count * (120 / ((maxSessions == 0) ? 1 : maxSessions))
                        
                        if (barHeight == 0) {
                            RoundedRectangle(cornerRadius: 10).frame(width: 7, height: 120)
                                .opacity(0.0)
                        } else {
                            Rectangle()
                                .frame(width: 7, height: CGFloat(barHeight))
                                .foregroundColor(.softMint)
                                .cornerRadius(10, corners: [.topLeft, .topRight])
                        }
                    }
                }
            }
            
            HStack(alignment: .bottom) {
                Text("12 AM").font(.system(size: 12))
                Spacer()
                Text("6 AM").font(.system(size: 12))
                Spacer()
                Text("12 PM").font(.system(size: 12))
                Spacer()
                Text("6 PM").font(.system(size: 12))
                Spacer()
            }
            .padding([.leading, .trailing], 15)
        }
    }
    
    var body: some View {

        switch (trendsView) {
        case .day:
            dayChart()
                .padding(.top, 45)
                .frame(height: 135)
        case .week:
            weekChart()
                .padding(.top, 25)
                .frame(height: 135)
        case .month:
            weekChart()
                .padding(.top, 25)
                .frame(height: 135)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(sessions: [SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200), SessionLog(id: UUID(), date: Date(), completed: true, type: .work, length: 1200)], trendsView: .constant(.day), dateSelection: .constant(Date()))
    }
}
