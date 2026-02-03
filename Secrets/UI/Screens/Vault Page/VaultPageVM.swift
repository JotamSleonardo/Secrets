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
    public final class ViewModel: ObservableObject {
        let container: DIContainer

        @Published var items: [VaultItemDTO] = []
        @Published var searchText: String = ""
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func getItems() {
            guard let key = container.session.key else { return }
            do {
                self.items = try self.container
                    .services
                    .vaultPageService
                    .list(using: key)
            } catch {
                self.items = []
            }
            
        }
        
        func getFavoritesItems() -> [VaultItemDTO] {
            return self.items.filter { $0.isFavorite }
        }
        
        func getOtherItems() -> [VaultItemDTO] {
            return self.items.filter { !$0.isFavorite }
        }
        

        func add(_ item: VaultItemForm) {
            guard let key = container.session.key else { return }
            try! self.container
                .services
                .vaultPageService
                .add(
                    vaultItem: item,
                    using: key
                )
        }
        
        func delete(_ vaultItem: VaultItemDTO) {
            
        }

        func edit(_ item: VaultItemForm) {
            guard let key = container.session.key else { return }
            try! self.container
                .services
                .vaultPageService
                .update(
                    vaultItem: item,
                    using: key
                )
        }

//        func delete(at offsets: IndexSet) {
//            items.remove(atOffsets: offsets)
//        }
//
//        func toggleFavorite(_ item: VaultItem) {
//            guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
//            items[idx].isFavorite.toggle()
//            items[idx].updatedAt = Date()
//        }
    }
}
