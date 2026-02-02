//
//  SecretsPage.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI
internal import Combine

struct VaultPage: View {
    @ObservedObject private(set) var viewModel: ViewModel = ViewModel()

    @State private var showAddSheet = false
    @State private var editingItem: VaultItemEntry? = nil

    var body: some View {
        NavigationStack {
            List {
                if !favorites.isEmpty {
                    Section("Favorites") {
                        ForEach(favorites) { item in
                            VaultItemView(item: item)
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
                            VaultItemView(item: item)
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
                            // Hook this to your lock action (e.g., set isUnlocked = false)
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
                EditVaultItemView(mode: .edit(item)) { updated in
                    viewModel.edit(updated)
                }
            }
        }
    }

    private var filtered: [VaultItemEntry] {
        let q = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return viewModel.items }

        return self.viewModel.items.filter { item in
            item.title.lowercased().contains(q) ||
            item.username.lowercased().contains(q) ||
            item.url.lowercased().contains(q) ||
            item.notes.lowercased().contains(q)
        }
    }

    private var favorites: [VaultItemEntry] {
        self.filtered.filter { $0.isFavorite }
    }

    private var allItems: [VaultItemEntry] {
        self.filtered.filter { !$0.isFavorite }
    }

    private func delete(_ item: VaultItemEntry) {
        viewModel.items.removeAll { $0.id == item.id }
    }
}
