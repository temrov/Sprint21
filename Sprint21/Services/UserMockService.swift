//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation
import Combine

final class UserMockService: @unchecked Sendable {
    private var users = CurrentValueSubject<[User], Never>([User]())
    private var isFetchingUsers = CurrentValueSubject<Bool, Never>(false)

    private let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }
}

extension UserMockService: UserService {
    var isFetchingPublisher: AnyPublisher<Bool, Never> {
        isFetchingUsers.eraseToAnyPublisher()
    }
    
    var usersPublisher: AnyPublisher<[User], Never> {
        users.eraseToAnyPublisher()
    }
    
    func fetchUsers() {
        guard users.value.isEmpty, isFetchingUsers.value == false else { return }
        isFetchingUsers.send(true)
        let group = DispatchGroup()

        for i in 0..<fetcher.usersCount {
            fetcher.fetchUser(with: i) { [weak self] result in
                defer {
                    group.leave()
                }
                guard let result, let self else { return }
                var allUsers = users.value
                allUsers.insert(result, at: allUsers.indexToInsertUser(with: result.id))
                self.users.send(allUsers)
            }
            group.enter()
        }
        group.notify(queue: .main) { [weak self] in
            // все пользователи загружены
            self?.isFetchingUsers.send(false)
        }
    }
}

extension UserMockService {
    static var `default`: UserMockService {
        UserMockService(fetcher: UserMockFetcher())
    }
}


