//
//  ProductCard.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: product.imageName ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Text(product.name)
                .font(.headline)
            
            Text("$\(String(format: "%.2f", product.price))")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

//#Preview {
//    ProductCard(product: <#Product#>)
//}
