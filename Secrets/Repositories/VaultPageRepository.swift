//
//  VaultPageRepository.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/2/26.
//

import Foundation
import CryptoKit
import SwiftData

protocol VaultPageRepository {
    func list(using key: SymmetricKey) throws -> [VaultItemDTO]
    
    func add(title: String, username: String, password: String, using key: SymmetricKey) throws
    
    func update(id: UUID, title: String, username: String, password: String, using key: SymmetricKey) throws
    
    func delete(id: UUID) throws
}

public final class VaultPageRepositoryImpl: VaultPageRepository {
    
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }
    
    func list(using key: SymmetricKey) throws -> [VaultItemDTO] {
        let descriptor = FetchDescriptor<VaultItem>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        let entries = try self.context.fetch(descriptor)

        return try entries.map { e in
            let password = try e.passwordCipher.decrypt(using: key)
            return VaultItemDTO(
                id: e.id,
                title: e.title,
                username: e.username ?? "",
                password: password,
                isFavorite: e.isFavorite,
                updatedAt: e.updatedAt
            )
        }
    }
    
    func add(title: String, username: String, password: String, using key: SymmetricKey) throws {
        let cipher = try password.encrypt(using: key)
        let entry = VaultItem(
            title: title,
            username: username.isEmpty ? nil : username,
            passwordCipher: cipher
        )
        self.context.insert(entry)
        try self.context.save()
    }
    
    func update(id: UUID, title: String, username: String, password: String, using key: SymmetricKey) throws {
        let descriptor = FetchDescriptor<VaultItem>(
            predicate: #Predicate { $0.id == id }
        )
        guard let entry = try self.context.fetch(descriptor).first else { return }

        entry.title = title
        entry.username = username.isEmpty ? nil : username
        entry.passwordCipher = try password.encrypt(using: key)
        entry.updatedAt = .now

        try self.context.save()
    }
    
    func delete(id: UUID) throws {
        let descriptor = FetchDescriptor<VaultItem>(
            predicate: #Predicate { $0.id == id }
        )
        if let entry = try self.context.fetch(descriptor).first {
            self.context.delete(entry)
            try self.context.save()
        }
    }
}
