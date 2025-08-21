//
//  AppStateManager.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import Foundation

enum AppModes: String {
    case auth
    case tab
}

final class UIState: ObservableObject {
    
    @Published var currenState: AppModes = LocalStorage.appCurrentState()
    
    func changeTab(to state: AppModes) {
        DispatchQueue.main.async { [weak self] in
            self?.currenState = state
        }
    }
    
}

final class LocalStorage {
    
    // save current state for app
    static func setCurrentState(_ value: AppModes) {
        UserDefaults.standard.set(value.rawValue, forKey: "appState")
    }
    
    // get current saved state of app.
    static func appCurrentState() -> AppModes {
        let appState = UserDefaults.standard.string(forKey: "appState") ?? ""
        return AppModes(rawValue: appState) ?? .auth
    }
    
    
    // save current user name
    static func setCurrentUser(_ value: String) {
        UserDefaults.standard.set(value, forKey: "userName")
    }
    
    // get Current User from Storage.
    static func getCurrentUser() -> User? {
        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        return CoreDataManager.shared.fetchUser(username: userName)
    }
    
    static func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: "userName")
    }
    
}



