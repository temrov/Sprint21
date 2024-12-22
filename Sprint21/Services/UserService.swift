//
//  UserService.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//
import Combine

protocol UserService {
    func fetchUsers()

    var isFetchingPublisher: AnyPublisher<Bool, Never> { get }
    var usersPublisher: AnyPublisher<[User], Never> { get }
}
