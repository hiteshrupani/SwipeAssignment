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
    
    @Published private var allProducts: Products = []
    var productsToDisplay: Products {
        // getting locally saved products if offline
        let localProducts = networkMonitor.isConnected ? [] :
        CoreDataManager.shared.fetchSavedProducts().map { productEntity in
            GetProductResponse(
                image: nil,
                price: Double(productEntity.price ?? "0") ?? 0,
                productName: productEntity.name,
                productType: productEntity.type,
                tax: Double(productEntity.tax ?? "0") ?? 0
            )
        }
        
        let combinedProducts = localProducts + allProducts
        
        // filtering based on search text
        let filteredProducts = searchText.isEmpty ? combinedProducts : combinedProducts.filter { (product) -> Bool in
            let lowercasedText = searchText.lowercased()
            
            return (product.productName ?? "").lowercased().contains(lowercasedText) ||
            (product.productType ?? "").lowercased().contains(lowercasedText)
        }
        
        // sorting favorite elements on top
        return filteredProducts.sorted {
            CoreDataManager.shared.isFavorite($0) && !CoreDataManager.shared.isFavorite($1)
        }
    }
    
    @Published var searchText: String = ""
    
    @Published var productToAdd: AddProductRequest?
    @Published var productImage: UIImage?
    
    // MARK: - Fetches products from server
    func loadProducts() async {
        let products = await productService.getProducts()
        
        if !products.isEmpty && products != allProducts || allProducts.isEmpty {
            print("Updated products list")
            allProducts = products
        }
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
            let productDetails = AddProductRequest(
                name: product.name ?? "Unknown",
                type: product.type ?? "Unknown",
                price: product.price ?? "0.00",
                tax: product.tax ?? "0.00"
            )
            
            let image = product.imageData.flatMap { UIImage(data: $0) }
            
            await productService.addProduct(product: productDetails, image: image)
            
            CoreDataManager.shared.deleteSavedProduct(product)
        }
    }

    // MARK: - Check connection status
    func startNetworkMonitoring() {
        Task {
            for await _ in networkMonitor.$isConnected.values where networkMonitor.isConnected {
                await uploadLocalProducts()
                print("Loading products within Network Monitoring")
                await loadProducts()
            }
        }
    }
}
