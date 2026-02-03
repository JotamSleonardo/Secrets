//
//  VaultItem.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/2/26.
//

import SwiftUI
import SwiftData

@Model
final class VaultItem: Identifiable {
    @Attribute(.unique) var id: UUID

    var title: String
    var username: String?
    var passwordCipher: Data
    var notesCipher: Data?
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(
        title: String,
        username: String? = nil,
        passwordCipher: Data,
        notesCipher: Data? = nil,
        isFavorite: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = UUID()
        self.title = title
        self.username = username
        self.passwordCipher = passwordCipher
        self.notesCipher = notesCipher
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
