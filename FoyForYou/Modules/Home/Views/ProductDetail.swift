//
//  ProductDetail.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject var viewModal: ProductDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var cartItemCount: Int
    init(viewModal: ProductDetailViewModel, cartItemCount: Binding<Int>) {
        _viewModal = StateObject(wrappedValue: viewModal)
        _cartItemCount = cartItemCount
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                productImage
                productDetails
            }
            .padding(.bottom)
            addToCartButton
            
        }
        .navigationTitle("\(viewModal.product.name)")
        .customAlert(
            isPresented: $viewModal.showAlert,
            message: viewModal.alertMessage ?? ""
        ) {
            dismiss()
        }
    }
}

//#Preview {
//    ProductDetailView(product: Products(id: 1, name: "asdfasd", price: 23, imageName: "house", description: "sdafas askdjfaskjdfha asjdkfha kskjasdhf kja sfkajhdsdafas askdjfaskj"))
//}


extension ProductDetailView {
    private var productImage: some View {
        Image(systemName: viewModal.product.imageName ?? "")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
    }
    
    private var productDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("$\(String(format: "%.2f", viewModal.product.price))")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(viewModal.product.productDescription ?? "")
                .font(.body)
                .foregroundColor(.gray)
            
            HStack {
                Stepper(value: $viewModal.quantity, in: 1...10) {
                    Text("Quantity: \(viewModal.quantity)")
                }
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
    
    private var addToCartButton: some View {
        Button(action: {
            if viewModal.addToCart() {
                withAnimation {
                    cartItemCount += 1
                }
            }
        }) {
            HStack {
                Spacer()
                Text("Add to Cart")
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
}
