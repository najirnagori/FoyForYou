//
//  CartView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModal = CartViewModel()
    @Binding var cartItemCount: Int
    
    var body: some View {
        VStack {
            if viewModal.cartItems.isEmpty {
                emptyCartView
            } else {
                cartItemRowList
                orderTotalAndCheckoutButton
            }
        }
        .onAppear(perform: {
            viewModal.loadCartItems()
            withAnimation {
              cartItemCount = 0
            }

        })
        .customAlert2(
            isPresented: $viewModal.showDeleteAlert,
            message: "Do you want to delete this item from your cart?"
        ) {
            viewModal.confirmRemoveItem()
        }
        .customNavLink (
            isActive: $viewModal.goToCheckout
        ) {
            CheckoutView(
                viewModal: CheckoutViewModel(
                    cartItems: viewModal.cartItems
                ))
        }
    }
}

#Preview {
    CartView(cartItemCount: .constant(0))
}


extension CartView {
    private var emptyCartView: some View {
        Group {
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.title2)
                .padding(.top)
            Spacer()
        }
    }
    
    private var cartItemRowList: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<viewModal.cartItems.count, id: \.self) { index in
                    cartItemRowView(index)
                }
            }
        }
    }
    
    private func cartItemRowView(_ index: Int) -> some View {
        VStack {
            HStack {
                Image(systemName: viewModal.cartItems[index].product.imageName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(viewModal.cartItems[index].product.name)
                        .font(.headline)
                    Text("$\(String(format: "%.2f", viewModal.cartItems[index].product.price))")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                itemCountAndDeleteButtons(index)
                
            }
            Divider()
        }
        .padding()
    }
    
    private func itemCountAndDeleteButtons(_ index: Int) -> some View {
        VStack(alignment: .trailing ,spacing: 10) {
            Button(action: {
                viewModal.removeItem(index)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            HStack {
                Button(action: {
                    viewModal.decreaseQuantity(
                        for: viewModal.cartItems[index],
                        cartItemIndex: index
                    )
                }) {
                    Image(systemName: "minus.circle")
                }
                
                Text("\(viewModal.cartItems[index].quantity)")
                    .frame(minWidth: 20)
                
                Button(action: {
                    viewModal.increaseQuantity(
                        for: viewModal.cartItems[index],
                        cartItemIndex: index
                    )
                }) {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
    
    private var orderTotalAndCheckoutButton: some View {
        VStack {
            Divider()
            orderTotal
            checkoutButton
        }
        .background(Color(.systemBackground))
    }
    
    private var orderTotal: some View {
        VStack {
            HStack {
                Text("Item Count:")
                    .font(.title2)
                Spacer()
                Text("$\(viewModal.itemCount)")
                    .font(.title2)
                    .bold()
            }
            HStack {
                Text("Total:")
                    .font(.title2)
                Spacer()
                Text("$\(String(format: "%.2f",viewModal.total))")
                    .font(.title2)
                    .bold()
            }
        }
        .padding(.horizontal)
    }
    
    private var checkoutButton: some View {
        Button {
            viewModal.goToCheckout = viewModal.canProceedToCheckout
        } label: {
            HStack {
                Spacer()
                Text("Proceed to Checkout")
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
        }
        .background(Color.blue)
        .cornerRadius(10)
        .padding()
    }
}
