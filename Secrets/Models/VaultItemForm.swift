//
//  VaultItemForm.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/3/26.
//
import Foundation

public struct VaultItemForm {
    var id: UUID?
    var title: String = ""
    var username: String = ""
    var password: String = ""
    var notes: String = ""
    var isFavorite: Bool = false
}
