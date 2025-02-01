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

    enum AlertType {
        case emptyFields
        case invalidEntry
        case success
    }
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showAlert: Bool = false
    
    @State var selectedCategory: ProductCategory?
    @State var nameText: String = ""
    @State var priceText: String = ""
    @State var taxText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    
    @State var alertType: AlertType = .emptyFields
    
    var anyFieldEmpty: Bool {
        if selectedCategory == nil || nameText == "" || priceText == "" || taxText == "" {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            // background
            
            VStack (spacing: 0) {
                header()
                
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
                        
                        VStack (spacing: 12) {
                            // MARK: - Category
                            categoryMenu()
                            
                            // MARK: - Text Fields
                            nameTextField()
                            priceTextField()
                            taxTextField()
                        }
                        .focused($textFieldIsFocused)
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
            showAlert(type: alertType)
        }
    }
    
    private func addProduct(){
        textFieldIsFocused = false
        if anyFieldEmpty {
            alertType = .emptyFields
            showAlert = true
        } else {
            viewModel.productToAdd = AddProductRequest(
                name: nameText,
                type: selectedCategory?.rawValue.capitalized ?? "Unknown",
                price: priceText,
                tax: taxText
            )
            Task {
                await viewModel.addProduct()
                viewModel.productImage = nil
                alertType = .success
                showAlert = true
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

extension ProductAddView {
    // MARK: - Header
    private func header() -> some View {
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
    }
    
    // MARK: - Image
    private func selectedImage(image: UIImage) -> some View {
        RoundedRectangle(cornerRadius: 25)
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
                    .fill(Color.gray.opacity(0.2))
            }
    }
    // MARK: - Category
    private func categoryMenu() -> some View {
        VStack (alignment: .leading) {
            Text("Category")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            // show menu on tapping this
            Menu {
                ForEach (ProductCategory.allCases, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack {
                            Text(category.rawValue.capitalized)
                                 
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                categoryButton()
            }
        }
    }
    
    private func categoryButton() -> some View {
        HStack {
            Text(selectedCategory?.rawValue.capitalized ?? "Select a category...")
                .font(.headline)
                .foregroundStyle(
                    selectedCategory != nil ?
                    Color.theme.text : Color(.systemGray2)
                )
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // MARK: - Name Text Field
    private func nameTextField() -> some View {
        VStack (alignment: .leading) {
            Text("Name")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            TextField("Enter name here...", text: $nameText)
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    // MARK: - Price Text Field
    private func priceTextField() -> some View {
        VStack(alignment: .leading) {
            Text("Price")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            TextField("Enter price here...", text: $priceText)
                .keyboardType(.decimalPad)
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    // MARK: - Tax Text Field
    private func taxTextField() -> some View {
        VStack(alignment: .leading) {
            Text("Tax")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            TextField("Enter tax here...", text: $taxText)
                .keyboardType(.decimalPad)
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    private func showAlert(type: AlertType) -> Alert {
        let dismissAlert: () -> Void = {
            showAlert = false
        }
        
        let successAction: () -> Void = {
            showAlert = false
            dismiss()
        }
        
        switch type {
        case .emptyFields:
            return Alert(
                title: Text("All fields are required!"),
                message: Text("Please fill in all the required fields to add a product."),
                dismissButton: .default(Text("Got it!"), action: dismissAlert)
            )
        case .invalidEntry:
            return Alert(
                title: Text("Oops!"),
                message: Text("You have entered an invalid value. Please try again."),
                dismissButton: .default(Text("Got it!"), action: dismissAlert)
            )
        case .success:
            return Alert(
                title: Text("Success!"),
                message: Text("The product has been added successfully!"),
                dismissButton: .default(Text("Got it!"), action: successAction)
            )
        }
    }
}
