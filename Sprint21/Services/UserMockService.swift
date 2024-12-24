//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import Combine

actor UserMockService: Sendable {
    private let fetcher: UserFetcher

    private var users = [User]()
    private var stream: AsyncStream<[User]>?

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }

    private func createStream() -> AsyncStream<[User]> {
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
                            users.insert(user, at: users.indexToInsertUser(with: user.id))
                            continuation.yield(users)
                        }
                    }
                    continuation.finish()
                }
            }
        }
    }
}

extension UserMockService: UserService {
    func fetchUsers() async -> AsyncStream<[User]> {
        if let stream {
            return stream
        }
        let stream = createStream()
        self.stream = stream
        return stream
    }
}

extension UserMockService {

    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


