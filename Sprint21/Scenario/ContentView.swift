//
//  ContentView.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UserList(model: UserListViewModel(userService: UserMockService.default))
            .onAppear {
                UserMockService.default.fetchUsers { _ in
                    
                }
            }
    }
}

#Preview {
    ContentView()
}
