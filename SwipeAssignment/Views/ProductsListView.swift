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
        List {
            ForEach (viewModel.allProducts) { product in
                ProductCardView(product: product)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .task {
            await viewModel.loadProducts()
        }
        .refreshable {
            await viewModel.loadProducts()
        }
        .navigationTitle("Products")
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ProductsListView()
    }
    .environmentObject(ProductsViewModel())
}
