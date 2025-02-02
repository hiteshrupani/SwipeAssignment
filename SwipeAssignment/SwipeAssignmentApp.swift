//
//  SwipeAssignmentApp.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

@main
struct SwipeAssignmentApp: App {
    
    @StateObject var productsViewModel = ProductsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProductsListView()
                    .onAppear {
                        productsViewModel.startNetworkMonitoring()
                    }
            }
            .environmentObject(productsViewModel)
        }
    }
}
