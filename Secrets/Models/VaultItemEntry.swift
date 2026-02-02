//
//  VaultItem.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/24/26.
//
import SwiftUI

struct VaultItemEntry: Identifiable, Hashable {
    let id: UUID
    var title: String
    var username: String
    var password: String
    var url: String
    var notes: String
    var isFavorite: Bool
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        username: String = "",
        password: String = "",
        url: String = "",
        notes: String = "",
        isFavorite: Bool = false,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.username = username
        self.password = password
        self.url = url
        self.notes = notes
        self.isFavorite = isFavorite
        self.updatedAt = updatedAt
    }
}
