//
//  ContentView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct ProductsListView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack {
                // MARK: - Header
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
                    SearchBarView(searchText: $searchText)
                }
                .padding()
                
                // MARK: - List
                List {
                    ForEach (viewModel.allProducts) { product in
                        ProductCardView(product: product)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.inset)
            }
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

extension ProductsListView {
    
}
