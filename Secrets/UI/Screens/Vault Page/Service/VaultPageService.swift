//
//  VaultPageService.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/3/26.
//

import Foundation
import CryptoKit

protocol VaultPageServiceType {
    func list(using key: SymmetricKey) throws -> [VaultItemDTO]
    func add(vaultItem: VaultItemForm, using key: SymmetricKey) throws
    func update(vaultItem: VaultItemForm, using key: SymmetricKey) throws
    func delete(id: UUID) throws
}

@MainActor
public final class VaultPageService: VaultPageServiceType {
    private let repo: VaultPageRepository

    init(repo: VaultPageRepository) {
        self.repo = repo
    }

    func list(using key: SymmetricKey) throws -> [VaultItemDTO] {
        try repo.list(using: key)
    }

    func add(vaultItem: VaultItemForm, using key: SymmetricKey) throws {
        try repo.add(vaultItem: vaultItem, using: key)
    }

    func update(vaultItem: VaultItemForm, using key: SymmetricKey) throws {
        try repo.update(vaultItem: vaultItem, using: key)
    }

    func delete(id: UUID) throws {
        try repo.delete(id: id)
    }
}
