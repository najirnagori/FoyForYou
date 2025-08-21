//
//  OrderHistoryView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModal = HistoryViewModel()
    var body: some View {
        VStack {
            if viewModal.orders.isEmpty {
                noOrderText
            } else {
                orderList
            }
        }
        .onAppear {
            viewModal.loadOrders()
        }
    }
}

#Preview {
    OrderHistoryView()
}


extension OrderHistoryView {
    
    private var noOrderText: some View {
        Group {
            Spacer()
            Text("No orders Yet!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private var orderList: some View {
        Group {
            ScrollView {
                ForEach(viewModal.orders, id: \.id) { order in
                    orderRow(order)
                }
            }
            Spacer()
        }
    }
    
    private func orderRow(_ order: Order) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Order Id: #\(order.id)")
                    .font(.headline)
                
                Text("Order Total: $\(order.totalAmount)")
                    .font(.subheadline)
                    .bold()
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Order Date: ") +
                Text(order.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Order Status: ") +
                Text("\(order.status ?? "")")
                    .foregroundColor(order.status == "Delivered" ? .green : .blue)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 3, x: 0, y: 2)
        .padding(.bottom, 10)
        .padding(.horizontal)

    }
}
