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
    @State private var editingItem: VaultItemDTO? = nil
    
    var body: some View {
        let favoriteItems = viewModel.getFavoritesItems()
        let allOtherItems = viewModel.getOtherItems()
        
        NavigationStack {
            List {
                if favoriteItems.isNotEmpty {
                    Section("Favorites") {
                        ForEach(favoriteItems) { item in
                            VaultItemView(
                                item: item,
                                onTap: {
                                    self.editingItem = item
                                },
                                onDelete: {
                                    viewModel.delete(item)
                                },
                                onToggleFavorite: {
                                    /// TODO: add toggle favorite
                                }
                            )
                        }
                    }
                }
                if allOtherItems.isNotEmpty {
                    Section("All") {
                        ForEach(allOtherItems) { item in
                            VaultItemView(
                                item: item,
                                onTap: {
                                    self.editingItem = item
                                },
                                onDelete: {
                                    viewModel.delete(item)
                                },
                                onToggleFavorite: {
                                    /// TODO: add toggle favorite
                                }
                            )
                        }
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
                VaultItemFormView(mode: .add) { newItem in
                    viewModel.add(newItem)
                    viewModel.getItems()
                }
            }
            .sheet(item: $editingItem) { item in
//                VaultItemFormView(mode: .edit(item)) { updateVaultItem in
//                    viewModel.edit(updateVaultItem)
//                }
            }
            .onAppear {
                viewModel.getItems()
            }
        }
    }

    // TODO: Add filtering/ searching.
    private var filtered: [VaultItem] {
        return []
    }
}
