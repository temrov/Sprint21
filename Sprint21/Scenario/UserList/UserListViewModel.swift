//
//  UserListViewModel.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import SwiftUI
import Combine

@Observable
final class UserListViewModel: @unchecked Sendable {
    var users: [User] = []
    var isLoading: Bool = false

    private let userService: UserService
    private var cancellables: Set<AnyCancellable> = []

    init(userService: UserService) {
        self.userService = userService
    }

    func fetchUsers() {
        userService.fetchUsers()
        userService.isFetchingPublisher.receive(on: RunLoop.main).sink { [weak self] in
            self?.isLoading = $0
        }.store(in: &cancellables)
        userService.usersPublisher.receive(on: RunLoop.main).sink { [weak self] in
            self?.users = $0
        }.store(in: &cancellables)
    }
}
