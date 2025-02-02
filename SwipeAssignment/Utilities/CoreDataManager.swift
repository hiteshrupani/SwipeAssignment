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
    
    // MARK: - CRUD Operations
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
