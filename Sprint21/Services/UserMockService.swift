//
//  UserMockService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Foundation

final class UserMockService {
    private let userNames: [String] = ["Vadim", "Sergey", "Alex", "Max", "Vlad", "Igor", "Oleg", "Artem", "Vitaly", "Dmitry"]
    private static func retrieveDelay() -> TimeInterval {
        Double.random(in: 1...3)
    }
}

extension UserMockService: UserService {
    func fetchUser(with id: Int, completion: @escaping @Sendable (User?) -> Void) {
        let user = userNames[safe: id].map( { User(id: id, name: $0)})
        DispatchQueue.global(qos: .userInitiated).asyncAfter(
            deadline: .now() + Self.retrieveDelay()
        ) {
            completion(user)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            guard index <= count else { return nil }
            return self[index]
        }
        set {
            guard index <= count, let newValue else { return }
            self[index] = newValue
        }
    }
}
