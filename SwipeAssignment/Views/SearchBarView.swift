//
//  SearchBarView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // MARK: - Magnifying Glass
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)
            
            // MARK: - Text Field
            TextField("Search by name or category...", text: $searchText)
                .foregroundStyle(Color.theme.text)
                .disableAutocorrection(true)
                .overlay(
                    // MARK: - Cross Button
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            // MARK: - Background
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.shadow,
                    radius: 10
                )
        )
    }
}

#Preview {
    SearchBarView(searchText: .constant("hello"))
}
