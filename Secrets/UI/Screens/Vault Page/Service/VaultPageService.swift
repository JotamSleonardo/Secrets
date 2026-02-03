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
    func add(title: String, username: String, password: String, using key: SymmetricKey) throws
    func update(id: UUID, title: String, username: String, password: String, using key: SymmetricKey) throws
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

    func add(title: String, username: String, password: String, using key: SymmetricKey) throws {
        try repo.add(title: title, username: username, password: password, using: key)
    }

    func update(id: UUID, title: String, username: String, password: String, using key: SymmetricKey) throws {
        try repo.update(id: id, title: title, username: username, password: password, using: key)
    }

    func delete(id: UUID) throws {
        try repo.delete(id: id)
    }
}
