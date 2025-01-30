//
//  ProductService.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation

class ProductService {
    func getProducts() async -> Products {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else { return [] }
        
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
}
