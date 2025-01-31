//
//  Color.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation
import SwiftUICore

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color.accentColor
    let text = Color(.label)
    let background = Color(.systemBackground)
    let groupedBackground = Color(.secondarySystemBackground)
    let shadow = Color.accentColor.opacity(0.33)
}
