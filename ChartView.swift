//
//  ChartView.swift
//  Concentration
//
//  Created by Sam Burkhard on 4/16/22.
//

import SwiftUI

struct ChartView: View {
    var body: some View {
        
        VStack {
            
            HStack(alignment: .bottom, spacing: 17) {
                ForEach(1..<13) { number in
                    VStack {
                        RoundedRectangle(cornerRadius: 10).frame(width: 12, height: 120)
                            .foregroundColor(.softGreen)
                        Text("\(number * 2)").font(.system(size: 12))
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
        ChartView()
    }
}
