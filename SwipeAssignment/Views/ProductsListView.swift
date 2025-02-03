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
            Color.theme.background.ignoresSafeArea()
            
            VStack {
                header()
                
                // MARK: - List
                if !viewModel.productsToDisplay.isEmpty {
                    List {
                        ForEach (viewModel.productsToDisplay) { product in
                            ProductCardView(product: product, favoriteAction: {
                                viewModel.toggleFavorite(for: product.id)
                            })
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
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

extension ProductsListView {
    // MARK: - Header
    private func header() -> some View {
        VStack  {
            HStack {
                // MARK: - Title
                Text("Products")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.accent)
                
                Spacer()
                
                // MARK: - Add product button
                NavigationLink {
                    ProductAddView()
                } label: {
                    CircleButtonView(iconName: "plus")
                }
            }
            
            // MARK: - Search
            SearchBarView(searchText: $viewModel.searchText)
        }
        .padding()
    }
}
