//
//  AddProductModel.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import Foundation

struct AddProductResponse: Codable {
    let errorCode: String?
    let message: String?
    let requestId: String?
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message
        case requestId = "request_id"
        case success
    }
}

struct AddProductRequest: Codable {
    let name: String
    let type: String
    let price: String
    let tax: String
}

enum ProductCategory: String, CaseIterable {
    case groceries
    case electronics
    case fashion
    case home
    case beauty
    case sports
    case education
    case toys
}
