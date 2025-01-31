//
//  ProductService.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation
import UIKit

class ProductService {
    func getProducts() async -> Products {
        let endpoint = "get"
        guard let url = URL(string: Api.baseURL + endpoint) else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let data = try await NetworkManager.downloadData(fromURL: request)
            let decodedData = try JSONDecoder().decode(Products.self, from: data)
            print(decodedData)
            return decodedData
        } catch {
            print("error getting data from GET api", error)
            return []
        }
    }
    
    func addProduct(product: AddProductRequest, image: UIImage?) async {
        let endpoint = "add"
        guard let url = URL(string: Api.baseURL + endpoint) else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            // adding text fields
            let textParams: [String: String] = [
                "product_name" : product.name,
                "product_type" : product.type,
                "price" : product.price,
                "tax" : product.tax
            ]
            
            for (key, value) in textParams {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            // adding image
            if let image = image {
                guard let imageData = image.pngData() else { return }
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(UUID().uuidString).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            // closing body
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            request.httpBody = body
            
            let data = try await NetworkManager.downloadData(fromURL: request)
            let decodedData = try JSONDecoder().decode(AddProductResponse.self, from: data)
            print(decodedData)
        } catch {
            print("error adding product:", error)
        }
    }
}
