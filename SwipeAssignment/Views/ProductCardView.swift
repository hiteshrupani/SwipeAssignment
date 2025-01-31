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
            AsyncImage(url: URL(string: product.image ?? "")) { phase in
                if let image = phase.image {
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 125, maxHeight: 125)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            VStack (alignment: .leading) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing: 5){
                        Text(product.productName ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text(product.productType ?? "")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                            .padding(.vertical, 3)
                            .background {
                                Capsule()
                                    .opacity(0.2)
                            }
                    }
                    
                    Spacer()
                    
                    Button {
//                        product.isFavorite.toggle()
                    } label: {
                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(Color.black)
                            .font(.title)
                            .padding(.top, 5)
                            .padding(3)
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Text("\((product.price ?? 0.0).formatted(.currency(code: "INR")))")
                        .font(.title)
                        .fontWeight(.medium)
                    
                    Text("\((product.tax ?? 0.0).formatted())% GST")
                        .font(.subheadline)
                        .opacity(0.7)
                        .offset(y: 4)
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color(.label), lineWidth: 1)
        }
    }
}

#Preview {
    ProductCardView(product: Product(image: "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1738263477_0_image.jpg", price: 66.0, productName: "Daisies", productType: "Product", tax: 6.0))
}
