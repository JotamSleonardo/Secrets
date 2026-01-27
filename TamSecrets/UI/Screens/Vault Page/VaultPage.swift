//
//  SecretsPage.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI
internal import Combine

struct VaultPage: View {
    @StateObject private var store = VaultStore()

    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var editingItem: VaultItem? = nil

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
                                        store.toggleFavorite(item)
                                    } label: {
                                        Label(item.isFavorite ? "Unfavorite" : "Favorite",
                                              systemImage: item.isFavorite ? "star.slash" : "star")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }

                Section("All") {
                    ForEach(others) { item in
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
                                    store.toggleFavorite(item)
                                } label: {
                                    Label(item.isFavorite ? "Unfavorite" : "Favorite",
                                          systemImage: item.isFavorite ? "star.slash" : "star")
                                }
                                .tint(.yellow)
                            }
                    }
                    .onDelete(perform: store.delete)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Vault")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditVaultItemView(mode: .edit(item)) { updated in
                    store.update(updated)
                }
            }
        }
    }

    private var filtered: [VaultItem] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return store.items }

        return store.items.filter { item in
            item.title.lowercased().contains(q) ||
            item.username.lowercased().contains(q) ||
            item.url.lowercased().contains(q) ||
            item.notes.lowercased().contains(q)
        }
    }

    private var favorites: [VaultItem] {
        filtered.filter { $0.isFavorite }
    }

    private var others: [VaultItem] {
        filtered.filter { !$0.isFavorite }
    }

    private func delete(_ item: VaultItem) {
        store.items.removeAll { $0.id == item.id }
    }
}

@MainActor
final class VaultStore: ObservableObject {
    @Published var items: [VaultItem] = [
        .init(title: "Google", username: "jotam@gmail.com", password: "••••••••", url: "https://accounts.google.com", notes: "2FA enabled", isFavorite: true),
        .init(title: "GitHub", username: "jotam", password: "••••••••", url: "https://github.com", notes: "", isFavorite: false),
        .init(title: "Netflix", username: "jotam@email.com", password: "••••••••", url: "https://netflix.com", notes: "Family plan", isFavorite: false)
    ]

    func add(_ item: VaultItem) {
        items.insert(item, at: 0)
    }

    func update(_ item: VaultItem) {
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

