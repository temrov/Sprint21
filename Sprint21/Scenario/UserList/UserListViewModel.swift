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

    func fetchUsers() {
        isLoading = true
        let group = DispatchGroup()
        for i in 0..<10 {
            userService.fetchUser(with: i) { [weak self] result in
                DispatchQueue.main.async {
                    defer {
                        group.leave()
                    }
                    guard let result, let self else { return }
                    self.users.insert(result, at: self.users.indexToInsertUser(with: result.id))
                }
            }
            group.enter()
        }
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
}
