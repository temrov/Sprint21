//
//  UserList.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

import SwiftUI

struct UserList: View {
    @State var model: UserListViewModel
    var body: some View {
        List {
            Text("Status: \(model.isLoading ? "Loading..." : "Loaded")")
            Section("Users") {
                ForEach(model.users, id: \.self) { user in
                    UserListItem(user: user)
                }
            }
        }
        .onAppear {
            model.preheatUsers()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                model.fetchUsers()
            }
        }
    }
}
