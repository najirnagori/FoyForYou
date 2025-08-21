//
//  CheckoutView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject var viewModal: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModal: CheckoutViewModel) {
        _viewModal = StateObject(wrappedValue: viewModal)
    }
    
    var body: some View {
        ZStack {
            Form {
                addressTextField
                paymentSelectionPicker
                orderSummarySection
                placeOrderButton
            }
                successScreen
        }
        .animation(
            .easeInOut,
            value: viewModal.showSuccessScreen
        )
        .customAlert(
            isPresented: $viewModal.showAlert,
            message: viewModal.alertMessage ?? ""
        )
    }
}

//#Preview {
//    CheckoutView()
//}


extension CheckoutView {
    private var addressTextField: some View {
        Section(header: Text("Shipping Information")) {
            TextField("Shipping Address", text: $viewModal.shippingAddress)
        }
    }
    
    private var paymentSelectionPicker: some View {
        Section(header: Text("Payment Method")) {
            Picker("Payment Method", selection: $viewModal.paymentType) {
                ForEach(PaymentType.allCases, id: \.self) {
                    Text($0.title)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var orderSummarySection: some View {
        Section(header: Text("Order Summary")) {
            ForEach(0..<viewModal.orderItems.count, id: \.self) { index in
                HStack {
                    Text("\(viewModal.orderItems[index].product.name) × \(viewModal.orderItems[index].quantity)")
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModal.orderItems[index].product.price * Double(viewModal.orderItems[index].quantity)))")
                }
            }
            
            HStack {
                Text("Total")
                    .font(.headline)
                Spacer()
                Text("$\(viewModal.subtotal)")
                    .font(.headline)
            }
        }
    }
    
    private var placeOrderButton: some View {
        Section {
            Button(action: {
                viewModal.authenticatePay()
            }) {
                HStack {
                    Spacer()
                    Text("Place Order Via \(viewModal.paymentType.title)")
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                }
            }
            .listRowBackground(Color.blue)
        }
    }
    
    @ViewBuilder
    private var successScreen: some View {
        if viewModal.showSuccessScreen {
            SuccessFullScreen(paymentMessage: viewModal.alertMessage ?? "") {
                // Auto dismiss after animation
                dismiss()
            }
            .transition(.opacity)
            .zIndex(1)
        }
    }
}
