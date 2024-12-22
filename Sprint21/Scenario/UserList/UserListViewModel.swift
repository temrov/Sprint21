//
//  UserListViewModel.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import SwiftUI

@Observable
final class UserListViewModel: @unchecked Sendable {
    var users: [User] = []
    var isLoading: Bool = false

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }

    @MainActor
    func fetchUsers() {
        isLoading = true
        userService.fetchUsers { [weak self] users in
            self?.users = users
            self?.isLoading = false
        }
    }
}
