//
//  ProductAddView.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 31/01/25.
//

import SwiftUI
import PhotosUI

struct ProductAddView: View {
    @EnvironmentObject var viewModel: ProductsViewModel
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showAlert: Bool = false
    
    @State var nameText: String = ""
    @State var typeText: String = ""
    @State var priceText: String = ""
    @State var taxText: String = ""
    
    var body: some View {
        ZStack {
            // background
            
            ScrollView {
                VStack {
                    // Image
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        if let image = viewModel.productImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: Screen.width)
                                .frame(height: Screen.height * 0.4)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.vertical)
                            
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.gray)
                                .frame(width: 150, height: 150)
                                .frame(maxWidth: .infinity)
                                .frame(height: Screen.height * 0.4)
                                .background {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .padding(.vertical)
                        }
                    }
                    
                    // Name
                    TextField("Name", text: $nameText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                    
                    // Type
                    TextField("Type", text: $typeText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                    
                    // Price
                    TextField("Price", text: $priceText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                        .keyboardType(.decimalPad)
                    
                    // Tax
                    TextField("Tax", text: $taxText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                        .keyboardType(.decimalPad)
                    
                    
                    // Add Button
                    Button {
                        if nameText == "" ||
                            typeText == "" ||
                            priceText == "" ||
                            taxText == "" {
                            showAlert = true
                        } else {
                            viewModel.productToAdd = AddProductRequest(
                                name: nameText,
                                type: typeText,
                                price: priceText,
                                tax: taxText
                            )
                            Task {
                                await viewModel.addProduct()
                            }
                        }
                    } label: {
                        Text("Add Product")
                            .foregroundStyle(Color(.systemBackground))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                            }
                    }
                }
            }
            .padding()
            .frame(width: Screen.width)
        }
        .onChange(of: photosPickerItem) {_, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        viewModel.productImage = image
                        
                    }
                }
                photosPickerItem = nil
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text("All fields are required!"),
                  dismissButton: .default(Text("Got it!")) {
                showAlert = false
            }
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProductAddView()
    }
    .environmentObject(ProductsViewModel())
}
