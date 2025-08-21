//
//  HomeView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModal: HomeViewModel = HomeViewModel()
    @Binding var cartItemCount: Int
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModal.products, id: \.id) { product in
                    NavigationLink(
                        destination: ProductDetailView(
                            viewModal: ProductDetailViewModel(product: product),
                            cartItemCount: $cartItemCount)
                    ) {
                        ProductCard(product: product)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(cartItemCount: .constant(0))
}
