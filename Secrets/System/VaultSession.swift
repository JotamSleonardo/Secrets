//
//  VaultSession.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/3/26.
//
import CryptoKit
internal import Combine

@MainActor
final class VaultSession: ObservableObject {
    @Published private(set) var isUnlocked = false
    private var key: SymmetricKey?

    func unlock(with key: SymmetricKey) {
        self.key = key
        self.isUnlocked = true
    }

    func lock() {
        self.key = nil
        self.isUnlocked = false
    }
}
