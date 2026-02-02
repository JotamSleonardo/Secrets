//
//  VaultItemDTO.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/2/26.
//
import Foundation

struct VaultItemDTO: Identifiable {
    let id: UUID
    let title: String
    let username: String
    let password: String
    let isFavorite: Bool
    let updatedAt: Date
}
