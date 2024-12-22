//
//  UserService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

protocol UserService {
    func fetchUser(with id: Int, completion: @escaping @Sendable (User?) -> Void)
}
