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
            //            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                // MARK: - Header
                VStack {
                    HStack {
                        // title
                        Text("Products")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // add product button
                        NavigationLink {
                            ProductAddView()
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle()
                                        .foregroundStyle(Color.white)
                                }
                                .shadow(radius: 10)
                        }
                    }
                    .padding()
                    
                    // search
                    
                    
                }
                
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
