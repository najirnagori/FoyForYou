//
//  NavigationModifier.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import SwiftUI

// MARK: Custom Navigation ViewModifier
struct NavigationViewModifier<T: View>: ViewModifier {
    let destination: T
    @Binding var isActiveVar: Bool
    func body(content: Content) -> some View {
        content
            .background(
                NavigationLink("",
                               destination: destination,
                               isActive: $isActiveVar)
            )
    }
}

extension View {
    func customNavLink<V: View>(isActive: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View {
        modifier(NavigationViewModifier(destination: destination(), isActiveVar: isActive))
    }
}
