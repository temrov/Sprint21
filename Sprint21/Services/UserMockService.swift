//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import Combine

actor UserMockService: Sendable {

    private var users = [User]()
    private var fetchingTask: Task<[User], Never>?

    private let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }
}

extension UserMockService: UserService {

    func fetchUsers() async -> [User] {
        print("Fetch started")
        defer { print("Fetch finished") }
        if let fetchingTask {
            return await fetchingTask.value
        }

        let fetchingTask = Task {
            await withTaskGroup(of: User?.self) { group in
                for i in 0 ..< fetcher.usersCount {
                    group.addTask {
                        await self.fetcher.fetchUser(with: i)
                    }
                }
                while let result = await group.next() {
                    if let user = result {
                        users.insert(user, at: users.indexToInsertUser(with: user.id))
                    }
                }
            }
            return users
        }
        self.fetchingTask = fetchingTask
        return await fetchingTask.value


    }
}

extension UserMockService {

    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


