//
//  UserMockFetcher.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation

protocol UserFetcher {
    var usersCount: Int { get }
    func fetchUser(with id: Int, completion: @escaping @Sendable (User?) -> Void)
}

final class UserMockFetcher {
    private let userNames: [String] = ["Vadim", "Sergey", "Alex", "Max", "Vlad", "Igor", "Oleg", "Artem", "Vitaly", "Dmitry"]

    private func retrieveDelay() -> TimeInterval {
        Double.random(in: 1...3)
    }
}

extension UserMockFetcher: UserFetcher {
    var usersCount: Int { userNames.count }
    
    func fetchUser(with id: Int, completion: @escaping @Sendable (User?) -> Void) {
        let user = userNames[safe: id].map( { User(id: id, name: $0)})
        DispatchQueue.global(qos: .userInitiated).asyncAfter(
            deadline: .now() + retrieveDelay()
        ) {
            completion(user)
        }
    }
}
