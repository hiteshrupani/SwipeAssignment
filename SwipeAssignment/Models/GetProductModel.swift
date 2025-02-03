//
//  ProductModel.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation

// MARK: - Product
struct GetProductResponse: Codable, Hashable, Equatable {
    let image: String?
    let price: Double?
    let productName: String?
    let productType: String?
    let tax: Double?

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

typealias Products = [GetProductResponse]
