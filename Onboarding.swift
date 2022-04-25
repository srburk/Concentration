//
//  Onboarding.swift
//  Concentrate
//
//  Created by Sam Burkhard on 4/24/22.
//

import SwiftUI

struct Onboarding: View {
    
    @EnvironmentObject var persistentStore: PersistenceStore
    
    @Environment(\.presentationMode) var presentationMode
    
    var numberedList: some View {
        
        VStack(alignment: .leading,spacing: 25) {
            
            Text("1.  Start a ") + Text("25 minute ").fontWeight(.semibold) + Text("work session")
            
            Text("2.  Take a ") + Text("5 minute ").fontWeight(.semibold) + Text("short break")
            
            Text("3.  After 4 work sessions, take a ") + Text("20 minute ").fontWeight(.semibold) + Text("long break")
            
        }
        .frame(width: 300)
        
    }
    
    var breakIndicator: some View {
        
        HStack(spacing: 8) {
            
            Image(systemName: "circle.fill")
                .foregroundColor(Color.softMint)
                .font(.system(size: 24, weight: .semibold))
            
            Image(systemName: "circle.fill")
                .foregroundColor(Color.softMint)
                .font(.system(size: 24, weight: .semibold))
            
            Image(systemName: "circle.lefthalf.filled")
                .foregroundColor(Color.softMint)
                .font(.system(size: 24, weight: .semibold))
            
            Image(systemName: "circle")
                .foregroundColor(Color.softMint)
                .font(.system(size: 24, weight: .semibold))
            
        }
        
    }

    var body: some View {
        
        VStack(spacing: 25) {
            
            Image("Concentrate")
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(CGFloat(35))
                .shadow(radius: 5)
                .padding()
            
            Text("Concentrate").font(.system(size: 30, weight: .semibold))
            
            Divider()
            
            Text("Concentrate was designed using the Pomodoro concentration method")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            numberedList
            
            breakIndicator
            
            Text("These times are just suggestions–feel free to change them however you'd like")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                        
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundColor(.softMint)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
            }.padding()
        }.padding()
        
        .onDisappear {
            persistentStore.saveDemoData()
        }
        
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
