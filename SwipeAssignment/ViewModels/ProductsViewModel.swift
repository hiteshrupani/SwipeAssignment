//
//  ProductsViewModel.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation
import UIKit

@MainActor
class ProductsViewModel: ObservableObject {
    private let productService = ProductService()
    
    @Published var allProducts: Products = []
    var productsToDisplay: Products {
        if searchText == "" {
            return allProducts.sorted { $0.isFavorite && !$1.isFavorite }
        } else {
            return allProducts.filter { (product) -> Bool in
                let lowercasedText = searchText.lowercased()
                return (product.productName ?? "").lowercased().contains(lowercasedText) ||
                (product.productType ?? "").lowercased().contains(lowercasedText)
            }
            .sorted { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    @Published var searchText: String = ""
    
    @Published var productToAdd: AddProductRequest?
    @Published var productImage: UIImage?
    
    func loadProducts() async {
        let products = await productService.getProducts()
        allProducts = products
    }
    
    func addProduct() async {
        if let productToAdd {
            await productService.addProduct(product: productToAdd, image: productImage)
        } else {
            print("No product to add!")
        }
    }
    
    func toggleFavorite(for productId: UUID) {
        if let index = allProducts.firstIndex(where: { $0.id == productId }) {
            allProducts[index].toggleFavorite()
        }
    }
}
