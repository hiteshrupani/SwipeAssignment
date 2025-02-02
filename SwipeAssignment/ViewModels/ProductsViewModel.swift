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
    private let networkMonitor = NetworkMonitor()
    
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
    
    // MARK: - Fetches products from server
    func loadProducts() async {
        let products = await productService.getProducts()
        allProducts = products
    }
    
    // MARK: - Uploads products to server or saves locally
    func addProduct() async {
        if let productToAdd {
            if networkMonitor.isConnected {
                await productService.addProduct(product: productToAdd, image: productImage)
            } else {
                CoreDataManager.shared.saveProduct(product: productToAdd, image: productImage)
            }
        } else {
            print("No product to add!")
        }
    }
    
    // MARK: - Uploads locally saved products
    func uploadLocalProducts() async {
        guard networkMonitor.isConnected else { return }
        
        let localProducts = CoreDataManager.shared.fetchSavedProducts()
        
        guard localProducts.count > 0 else { return }
        
        for product in localProducts {
            productToAdd = AddProductRequest(
                name: product.name ?? "Unknown",
                type: product.type ?? "Unknown",
                price: product.price ?? "0.00",
                tax: product.tax ?? "0.00"
            )
            
            productImage = product.imageData.flatMap { UIImage(data: $0) }
            
            await addProduct()
            
            productImage = nil
            
            CoreDataManager.shared.deleteSavedProduct(product)
        }
        await loadProducts()
    }
    
    // MARK: - Toggle Favorite Property
    func toggleFavorite(for productId: UUID) {
        if let index = allProducts.firstIndex(where: { $0.id == productId }) {
            allProducts[index].toggleFavorite()
        }
    }
    
    // MARK: - Check connection status
    func startNetworkMonitoring() {
        Task {
            for await _ in networkMonitor.$isConnected.values where networkMonitor.isConnected {
                await uploadLocalProducts()
            }
        }
    }
}
