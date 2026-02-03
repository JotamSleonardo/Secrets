//
//  SecretsPage.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI
internal import Combine

struct VaultPage: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @EnvironmentObject var session: VaultSession

    @State private var showAddSheet = false
    @State private var editingItem: VaultItem? = nil
    private let itemsample = VaultItemDTO(id: UUID(), title: "", username: "", password: "", isFavorite: false, updatedAt: Date.now)

    var body: some View {
        NavigationStack {
            List {
                if !favorites.isEmpty {
                    Section("Favorites") {
                        ForEach(favorites) { item in
                            VaultItemView(item: itemsample)
                                .contentShape(Rectangle())
                                .onTapGesture { editingItem = item }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        viewModel.toggleFavorite(item)
                                    } label: {
                                        Label(item.isFavorite ? "Unfavorite" : "Favorite",
                                              systemImage: item.isFavorite ? "star.slash" : "star")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
                if !allItems.isEmpty {
                    Section("All") {
                        ForEach(allItems) { item in
                            VaultItemView(item: itemsample)
                                .contentShape(Rectangle())
                                .onTapGesture { editingItem = item }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        viewModel.toggleFavorite(item)
                                    } label: {
                                        Label(item.isFavorite ? "Unfavorite" : "Favorite",
                                              systemImage: item.isFavorite ? "star.slash" : "star")
                                    }
                                    .tint(.yellow)
                                }
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Vault")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            self.session.lock()
                        } label: {
                            Label("Lock Vault", systemImage: "lock.fill")
                        }

                        Button {
                            UIPasteboard.general.string = ""
                        } label: {
                            Label("Clear Clipboard", systemImage: "doc.on.clipboard")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                EditVaultItemView(mode: .add) { newItem in
                    viewModel.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
//                EditVaultItemView(mode: .edit(item)) { updated in
//                    viewModel.edit(updated)
//                }
            }
        }
    }

    private var filtered: [VaultItem] {
        let q = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return viewModel.items }

        return []
//        return self.viewModel.items.filter { item in
//            item.title.lowercased().contains(q) ||
//            item.username.lowercased().contains(q) ||
//            item.url.lowercased().contains(q) ||
//            item.notes.lowercased().contains(q)
//        }
    }

    private var favorites: [VaultItem] {
        self.filtered.filter { $0.isFavorite }
    }

    private var allItems: [VaultItem] {
        self.filtered.filter { !$0.isFavorite }
    }

    private func delete(_ item: VaultItem) {
        viewModel.items.removeAll { $0.id == item.id }
    }
}
