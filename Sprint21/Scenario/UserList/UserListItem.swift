//
//  UserListItem.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

import SwiftUI

struct UserListItem: View {
    let user: User

    var body: some View {
        HStack {
            Text("\(user.id + 1).")
                .multilineTextAlignment(.leading)
                .frame(width: 40)
            Text(user.name)
            Spacer()
        }
    }
}

#Preview {
    UserListItem(user: User(id: 1, name: "Alex"))
}
