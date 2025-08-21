//
//  TabView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct TabsView: View {
    @State var cartItemCount: Int = 0
    @State var selectedTab: Tabs = .home
    enum Tabs: Hashable {
        case home, cart, history, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home
            NavigationView {
                HomeView(cartItemCount: $cartItemCount)
                    .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(Tabs.home)
            
            // Cart
            NavigationView {
                CartView(cartItemCount: $cartItemCount)
                    .navigationTitle("Cart")
                //                            .toolbar {
                //                                Button("Add Dummy") { cart.addDummyItem() }
                //                            }
            }
            .tabItem {
                Image(systemName: "cart.fill")
                Text("Cart")
            }
            .badge(cartItemCount > 0 ? cartItemCount : 0)
            .tag(Tabs.cart)
            
            // Checkout
            NavigationView {
                OrderHistoryView()
                    .navigationTitle("Order History")
            }
            .tabItem {
                Image(systemName: "creditcard.fill")
                Text("History")
            }
            .tag(Tabs.history)
            
            // Profile
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(Tabs.profile)
        }
        // Accent/tab selection color (works iOS 15)
        .accentColor(.teal)
    }
}

#Preview {
    TabsView()
}
