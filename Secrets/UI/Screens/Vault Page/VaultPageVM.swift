//
//  VaultPageVM.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
extension VaultPage {
    class ViewModel: ObservableObject {
        @Published var items: [VaultItem] = []
        @Published var searchText: String = ""

        func add(_ item: VaultItem) {
            items.insert(item, at: 0)
        }

        func edit(_ item: VaultItem) {
            guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
            items[idx] = item
        }

        func delete(at offsets: IndexSet) {
            items.remove(atOffsets: offsets)
        }

        func toggleFavorite(_ item: VaultItem) {
            guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
            items[idx].isFavorite.toggle()
            items[idx].updatedAt = Date()
        }
    }
}
