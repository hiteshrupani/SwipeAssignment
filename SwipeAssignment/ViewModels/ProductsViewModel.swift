//
//  ProductsViewModel.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation

@MainActor
class ProductsViewModel: ObservableObject {
    let productService = ProductService()
    
    @Published var allProducts: Products = []
    
    func loadProducts() async {
        let products = await productService.getProducts()
        allProducts = products
    }
}
