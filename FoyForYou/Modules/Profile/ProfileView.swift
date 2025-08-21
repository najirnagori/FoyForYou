//
//  ProfileView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct ProfileView: View {
    @State var currentUser: User? = LocalStorage.getCurrentUser()
    @EnvironmentObject var uiState: UIState
    
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("\(currentUser?.userName ?? "")")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical)
            }
            
            Section(header: Text("Account")) {
                Button(action: {
                    
                }) {
                    Label("Edit Profile", systemImage: "person.crop.circle")
                }
                
                Button(action: {
                    
                }) {
                    Label("Change Password", systemImage: "lock")
                }
            }
            
            
            
            Section {
                Button(action: {
                    LocalStorage.removeCurrentUser()
                    LocalStorage.setCurrentState(.auth)
                    uiState.changeTab(to: .auth)
                }) {
                    Label("Sign Out", systemImage: "arrow.left.square")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        
    }
}

#Preview {
    ProfileView()
}
