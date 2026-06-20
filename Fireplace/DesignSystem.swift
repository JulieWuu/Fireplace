//
//  DesignSystem.swift
//  Fireplace
//
//  Created by Julia Wu on 20/06/2026.
//


import SwiftUI

struct AppContentStyle: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Nunito Sans", size: size).weight(weight))
            .foregroundColor(.white)
    }
}

struct KomikaText: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Komika", size: size))
            .foregroundColor(.white)
    }
}

struct RenogareText: ViewModifier {
    var size: CGFloat
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Renogare", size: size))
            .foregroundColor(color)
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct AppTextFieldStyle: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Nunito Sans", size: size).weight(.regular))
            .foregroundColor(.white)
            .padding(10)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
    }
}

struct ListRowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .background(Color.clear)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.black).opacity(0.3))
                    .padding(3))
            .listRowInsets(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
    }
}

struct AppButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color
    var textSize: CGFloat
    var textWeight: Font.Weight
    var verticalPadding: CGFloat
    var horizontalPadding: CGFloat
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Nunito Sans", size: textSize).weight(textWeight))
            .foregroundColor(isEnabled ? textColor : Color.white.opacity(0.2))
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .offset(y: configuration.isPressed ? 3 : 0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func appContentStyle(size: CGFloat = 18, weight: Font.Weight = .regular) -> some View {
        self.modifier(AppContentStyle(size: size, weight: weight))
    }
    
    func komikaText(size: CGFloat = 16) -> some View {
        self.modifier(KomikaText(size: size))
    }
    
    func renogareText(size: CGFloat = 16, color: Color = .white) -> some View {
        self.modifier(RenogareText(size: size, color: color))
    }
    
    func appTextFieldStyle(size: CGFloat = 16) -> some View {
        self.modifier(AppTextFieldStyle(size: size))
    }
    
    func taskListStyle() -> some View {
        self.modifier(ListRowStyle())
    }
    
}

extension ButtonStyle where Self == AppButtonStyle {
    static var appBasic: Self {
        AppButtonStyle(backgroundColor: .gray.opacity(0.2), textColor: .white, textSize: 16, textWeight: .bold, verticalPadding: 12, horizontalPadding: 24)
    }
    
    static var appDestructive: Self {
        AppButtonStyle(backgroundColor: .red, textColor: .white, textSize: 16, textWeight: .bold, verticalPadding: 12, horizontalPadding: 24)
    }
    
    static func appButtonCustom(backgroundColor: Color = .gray.opacity(0.2), textColor: Color = .white, textSize: CGFloat = 16, textWeight: Font.Weight = .bold, verticalPadding: CGFloat = 12, horizontalPadding: CGFloat = 24) -> Self {
        AppButtonStyle(backgroundColor: backgroundColor, textColor: textColor, textSize: textSize, textWeight: textWeight, verticalPadding: verticalPadding, horizontalPadding: horizontalPadding)
    }
}
