//
//  Extensions.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 02/03/2022.
//

import SwiftUI

extension Color {
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> Color {
        return Color(UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha))
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
