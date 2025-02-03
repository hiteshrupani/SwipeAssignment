//
//  CoreDataManager.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 02/02/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Initialize Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProductContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data container failed to load: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - CRUD Operations for ProductEntity
    func saveProduct(product: AddProductRequest, image: UIImage?) {
        let context = persistentContainer.viewContext
        let productEntity = ProductEntity(context: context)
        
        productEntity.name = product.name
        productEntity.type = product.type
        productEntity.price = product.price
        productEntity.tax = product.tax
        
        productEntity.imageData = image?.jpegData(compressionQuality: 0.8)
        
        do {
            try context.save()
            print("Product saved locally.")
        } catch {
            print("Error saving product: \(error)")
        }
    }
    
    func fetchSavedProducts() -> [ProductEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching locally saved products: \(error)")
            return []
        }
    }
    
    func deleteSavedProduct(_ product: ProductEntity) {
        let context = persistentContainer.viewContext
        context.delete(product)
        
        do {
            try context.save()
            print("Product deleted successfully.")
        } catch {
            print("Error deleting product: \(error)")
        }
    }
}

extension CoreDataManager {
    // MARK: - For FavoriteProductEntity
    func toggleFavorite(for product: GetProductResponse) {
        let context = persistentContainer.viewContext
        
        let productKey = createProductKey(from: product)
        
        // To check if the product is already a favorite
        let fetchRequest: NSFetchRequest<FavoriteProductEntity> = FavoriteProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productKey == %@", productKey)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingFavorite = results.first {
                context.delete(existingFavorite)
            } else {
                let favorite = FavoriteProductEntity(context: context)
                favorite.productKey = productKey
            }
            try context.save()
            
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
    
    
    // Check if a product is a favorite
    func isFavorite(_ product: GetProductResponse) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteProductEntity> = FavoriteProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productKey == %@", createProductKey(from: product))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    
    
    // Create a unique key for the product
    private func createProductKey(from product: GetProductResponse) -> String {
        let components = [
            product.productName ?? "",
            product.productType ?? "",
            String(format: "%.2f", product.price ?? 0),
            String(format: "%.2f", product.tax ?? 0)
        ]
        
        return components.joined(separator: "-")
    }
}
