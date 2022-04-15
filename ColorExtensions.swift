//
//  ColorExtensions.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import Foundation
import SwiftUI

// MARK: Custom Colors
extension Color {
    
    public static var softGreen: Color {
        return Color(red: 144/255, green: 166/255, blue: 143/255)
    }
    
    public static var softGray: Color {
        return Color(red: 233/255, green: 233/255, blue: 233/255)
    }
    
    public static var softDarkGray: Color {
        return Color(red: 77/255, green: 77/255, blue: 77/255)
    }
    
    public static var softBlack: Color {
        return Color(red: 52/255, green: 52/255, blue: 52/255)
    }
}

// MARK: Custom View Modifiers

extension View {
    func primaryColor(colorScheme: ColorScheme) -> some View {
        modifier(PrimaryColor(colorScheme: colorScheme))
    }
    func secondaryColor(colorScheme: ColorScheme) -> some View {
        modifier(SecondaryColor(colorScheme: colorScheme))
    }
}

struct PrimaryColor: ViewModifier {
    
    var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        switch (colorScheme) {
        case .light:
            content
                .foregroundColor(.softBlack)
        case .dark:
            content
                .foregroundColor(.white)
        @unknown default:
            content
                .foregroundColor(.white)
        }
    }
}

struct SecondaryColor: ViewModifier {
    
    var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        switch (colorScheme) {
        case .light:
            content
                .foregroundColor(.softGray)
        case .dark:
            content
                .foregroundColor(.softDarkGray)
        @unknown default:
            content
                .foregroundColor(.softGray)
        }
    }
}
