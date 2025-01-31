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
    let productService = ProductService()
    
    @Published var allProducts: Products = []
    
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
}
