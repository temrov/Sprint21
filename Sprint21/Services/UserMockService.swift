//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation

actor UserMockService {

    private(set) var users = [User]()
    private(set) var isFetching = false

    private let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }

    private func fetchUser(with id: Int) async -> User? {
        await fetcher.fetchUser(with: id)
    }
}

extension UserMockService: UserService {

    func fetchUsers() async -> [User] {
        guard users.isEmpty, isFetching == false else {
            return users
        }
        defer {
            isFetching = false
        }
        self.users = await withTaskGroup(of: User?.self, returning: [User].self) { group in
            for i in 0 ..< fetcher.usersCount {
                group.addTask {
                    await self.fetchUser(with: i)
                }
            }
            var users: [User] = []
            while let result = await group.next() {
                if let user = result {
                    users.insert(user, at: users.indexToInsertUser(with: user.id))
                }
            }
            return users
        }
        return users
    }
}

extension UserMockService {

    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


