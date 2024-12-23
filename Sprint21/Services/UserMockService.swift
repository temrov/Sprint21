//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import Combine

actor UsersStorage {
    var users = [User]()
    var isFetching = false

    func insert(_ user: User) {
        users.insert(user, at: users.indexToInsertUser(with: user.id))
    }
    func fetchingStarted() {
        isFetching = true
    }
    func fetchingFinished() {
        isFetching = false
    }
}

final class UserMockService: Sendable {

    private let userStorage = UsersStorage()

    private let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }
}

extension UserMockService: UserService {
    func fetchUsers() async -> AsyncStream<[User]> {

        AsyncStream { continuation in
            Task {
                await withTaskGroup(of: User?.self) { group in
                    for i in 0 ..< fetcher.usersCount {
                        group.addTask {
                            await self.fetcher.fetchUser(with: i)
                        }
                    }
                    while let result = await group.next() {
                        if let user = result {
                            await userStorage.insert(user)
                            continuation.yield(await userStorage.users)
                        }
                    }
                    continuation.finish()
                }
            }
        }
    }
}

extension UserMockService {

    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


