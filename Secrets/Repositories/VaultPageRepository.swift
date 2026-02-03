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
    
    func add(vaultItem: VaultItemForm, using key: SymmetricKey) throws
    
    func update(vaultItem: VaultItemForm, using key: SymmetricKey) throws
    
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
            let notes = try e.notesCipher?.decrypt(using: key)
            return VaultItemDTO(
                id: e.id,
                title: e.title,
                username: e.username ?? "",
                password: password,
                isFavorite: e.isFavorite,
                notes: notes ?? "",
                updatedAt: e.updatedAt
            )
        }
    }
    
    func add(vaultItem: VaultItemForm, using key: SymmetricKey) throws {
        let passCipher = try vaultItem.password.encrypt(using: key)
        var notesCipher: Data? = nil
        if vaultItem.notes.isNotEmpty {
            notesCipher = try vaultItem.notes.encrypt(using: key)
        }
        let entry = VaultItem(
            title: vaultItem.title,
            username: vaultItem.username.isEmpty ? nil : vaultItem.username,
            passwordCipher: passCipher,
            notesCipher: notesCipher
        )
        
        self.context.insert(entry)
        try self.context.save()
    }
    
    func update(vaultItem: VaultItemForm, using key: SymmetricKey) throws {
        guard let id = vaultItem.id else { return }
        let descriptor = FetchDescriptor<VaultItem>(
            predicate: #Predicate { $0.id == id }
        )
        guard let entry = try self.context.fetch(descriptor).first else { return }

        entry.title = vaultItem.title
        entry.username = vaultItem.username.isEmpty ? nil : vaultItem.username
        entry.passwordCipher = try vaultItem.password.encrypt(using: key)
        entry.notesCipher = try vaultItem.notes.encrypt(using: key)
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
