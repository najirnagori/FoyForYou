//
//  AppView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState: UIState
    var body: some View {
        VStack {
//            NavigationView {
                VStack {
                    switch appState.currenState {
                    case .auth:
                        AuthView()
                    case .tab:
                        TabsView()
                    }
                }
//                .navigationViewStyle(.stack)
//                .environmentObject(appState)
//            }
        }
    }
}

#Preview {
    AppView()
}
