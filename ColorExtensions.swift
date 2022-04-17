//
//  ColorExtensions.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: Custom Colors
extension Color {
    
    public static var softGreen: Color {
        return Color(red: 144/255, green: 166/255, blue: 143/255)
    }
    
    public static var softMint: Color {
        return Color(red: 48/255, green: 176/255, blue: 199/255)
    }
    
    public static var softGray: Color {
        return Color(red: 233/255, green: 233/255, blue: 233/255)
    }
    
    public static var softDarkGray: Color {
        return Color(red: 92/255, green: 91/255, blue: 96/255)
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
