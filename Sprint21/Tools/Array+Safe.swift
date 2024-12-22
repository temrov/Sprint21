//
//  Array+Safe.swift
//  Sprint21
//
//  Created by Vadim Temnogrudov on 22.12.2024.
//

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
