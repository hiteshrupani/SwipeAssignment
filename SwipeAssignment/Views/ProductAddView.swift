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
    @Environment(\.dismiss) var dismiss
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showAlert: Bool = false
    
    @State var nameText: String = ""
    @State var typeText: String = ""
    @State var priceText: String = ""
    @State var taxText: String = ""
    
    var anyTextFieldEmpty: Bool {
        if nameText == "" || typeText == "" || priceText == "" || taxText == "" {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            // background
            
            VStack (spacing: 0) {
                // MARK: - Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        CircleButtonView(iconName: "arrow.left")
                    }
                    
                    Spacer()
                    
                    Text("Add Product")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.theme.accent)
                    
                    Spacer()

                    Button {
                        addProduct()
                    } label: {
                        CircleButtonView(iconName: "checkmark")
                    }
                
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.background)
                        .ignoresSafeArea()
                }
                
                // MARK: - Details
                ScrollView {
                    VStack (spacing: 20) {
                        // MARK: - Image
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            if let image = viewModel.productImage {
                                selectedImage(image: image)
                            } else {
                                placeholderImage()
                            }
                        }
                        
                        // MARK: - Text Fields
                        VStack (spacing: 12) {
                            stringTextField(title: "Name", fieldText: $nameText)
                            stringTextField(title: "Type", fieldText: $typeText)
                            numberTextField(title: "Price", fieldText: $priceText)
                            numberTextField(title: "Tax", fieldText: $taxText)
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
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
    
    private func addProduct(){
        if anyTextFieldEmpty {
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
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductAddView()
    }
    .environmentObject(ProductsViewModel())
}

// MARK: - SubView Functions
extension ProductAddView {
    private func selectedImage(image: UIImage) -> some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: .infinity)
            .frame(height: Screen.height * 0.4)
            .overlay(
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    private func placeholderImage() -> some View {
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
    }
    
    private func stringTextField(title: String, fieldText: Binding<String>) -> some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.headline)
                .opacity(0.8)
            
            TextField("Enter \(title.lowercased()) here...", text: fieldText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    private func numberTextField(title: String, fieldText: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .opacity(0.8)
            
            TextField("Enter \(title.lowercased()) here...", text: $priceText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .keyboardType(.decimalPad)
        }
    }
}
