//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation

final class UserMockService: @unchecked Sendable {

    private(set) var users = [User]()
    private(set) var isFetching = false

    private let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }
}

extension UserMockService: UserService {

    func fetchUsers(completion: @escaping ([User]) -> Void) {

        guard users.isEmpty, isFetching == false else {
            completion(users)
            return
        }
        isFetching = true
        let group = DispatchGroup()

        for i in 0..<fetcher.usersCount {
            fetcher.fetchUser(with: i) { [weak self] result in
                defer {
                    group.leave()
                }
                guard let result, let self else { return }
                self.users.insert(result, at: self.users.indexToInsertUser(with: result.id))
            }
            group.enter()
        }
        group.notify(queue: .main) { [weak self] in
            // все пользователи загружены
            guard let self else { return }
            self.isFetching = true
            completion(self.users)
        }
    }
}

extension UserMockService {

    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


