//
//  ProductCardView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct ProductCardView: View {
    var product: Product
    
    var body: some View {
        HStack {
            if product.image != "" {
                // MARK: - Image
                urlImage(url: product.image)
            } else {
                // MARK: - Placeholder Image
                urlImage(url: "https://placehold.co/100/jpg?text=?")
            }
            
            VStack (alignment: .leading) {
                HStack (alignment: .top) {
                    // MARK: - Product Name and Type
                    VStack (alignment: .leading, spacing: 5){
                        Text(product.productName ?? "")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        
                        Text(product.productType ?? "")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background {
                                Capsule()
                                    .opacity(0.2)
                            }
                    }
                    
                    Spacer()
                }
                
                // MARK: - Price and Tax
                HStack {
                    Text("\((product.price ?? 0.0).formatted(.currency(code: "INR")))")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("\((product.tax ?? 0.0).formatted())% GST")
                        .font(.footnote)
                        .opacity(0.7)
                        
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ProductCardView(product: Product(image: "", price: 66.0, productName: "Daisies", productType: "Product", tax: 6.0))
}

extension ProductCardView {
    // MARK: - Image
    private func urlImage(url: String?) -> some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            if let image = phase.image {
                image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
