//
//  ProductModel.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

// MARK: - Product
struct Product: Codable {
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

typealias Products = [Product]
