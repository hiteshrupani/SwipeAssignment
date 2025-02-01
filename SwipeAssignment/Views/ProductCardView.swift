//
//  ProductCardView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI

struct ProductCardView: View {
    var product: GetProductResponse
    
    var body: some View {
        HStack {
            if product.image != "" {
                // MARK: - Image
                urlImage(url: product.image)
            } else {
                // MARK: - Placeholder Image
                imagePlaceholder()
            }
            
            productDetails()
        }
        .frame(height: 100)
    }
}

#Preview {
    ProductCardView(product: GetProductResponse(image: "https://placehold.co/125/jpg?text=!\nOops!", price: 66.0, productName: "Daisies", productType: "Product", tax: 6.0))
}

extension ProductCardView {
    private func productDetails() -> some View {
        VStack (alignment: .leading, spacing: 15) {
            // MARK: - Product Name and Type
            VStack (alignment: .leading, spacing: 5) {
                Text(product.productType ?? "")
                    .font(.caption)
                    .opacity(0.7)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background {
                        Capsule()
                            .opacity(0.2)
                    }
                
                Text(product.productName ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
            }
            
            // MARK: - Price and Tax
            HStack (alignment: .bottom, spacing: 7.5) {
                Text("\((product.price ?? 0.0).formatted(.currency(code: "INR")))")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("\((product.tax ?? 0.0).formatted())% GST")
                    .font(.footnote)
                    .opacity(0.7)
                    .offset(y: -2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Image
    private func urlImage(url: String?) -> some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            if let image = phase.image {
                imageToDisplay(image: image)
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
    }
    
    private func imagePlaceholder() -> some View {
        imageToDisplay(image: Image(.productPlaceholder))
    }
    
    private func imageToDisplay(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
