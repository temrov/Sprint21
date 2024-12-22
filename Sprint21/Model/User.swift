//
//  User.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

struct User: Hashable, Sendable {
    let id: Int
    let name: String
}

extension Array where Element == User {
    func indexToInsertUser(with id: Int) -> Int {
        for iterator in self.enumerated() {
            if id <= iterator.element.id {
                return iterator.offset
            }
        }
        return self.count
    }
}
