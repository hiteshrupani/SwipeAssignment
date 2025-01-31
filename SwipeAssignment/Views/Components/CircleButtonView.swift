//
//  CircleButtonView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct CircleButtonView: View {
    var iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.theme.background)
            }
            .shadow(
                color: Color.theme.shadow,
                radius: 10
            )
    }
}

#Preview {
    CircleButtonView(iconName: "arrow.left")
}
