//
//  ContentView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct ProductsListView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            List {
                ForEach (viewModel.allProducts) { product in
                    ProductCardView(product: product)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.inset)
        }
        .task {
            await viewModel.loadProducts()
        }
        .refreshable {
            await viewModel.loadProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsListView()
    }
    .environmentObject(ProductsViewModel())
}
