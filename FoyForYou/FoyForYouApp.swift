//
//  FoyForYouApp.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

@main
struct FoyForYouApp: App {
    
    @StateObject var appState: UIState = UIState()
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(appState)
        }
    }
}
