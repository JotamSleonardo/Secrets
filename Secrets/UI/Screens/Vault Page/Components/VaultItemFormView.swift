//
//  EditVaultItemView.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/24/26.
//

import SwiftUI

public struct VaultItemFormView: View {
    let onSave: (VaultItemForm) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var form: VaultItemForm
    @State private var showPassword = false
    
    init(mode: Mode, onSave: @escaping (VaultItemForm) -> Void) {
        self.onSave = onSave
        switch mode {
            case .add:
                _form = State(initialValue: VaultItemForm())
            case .edit(let dto):
                _form = State(
                    initialValue: VaultItemForm(
                        id: dto.id,
                        title: dto.title,
                        username: dto.username,
                        password: dto.password,
                        notes: dto.notes,
                        isFavorite: dto.isFavorite
                    )
                )
        }
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $form.title)

                    TextField("Username / Email", text: $form.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password", text: $form.password)
                            } else {
                                SecureField("Password", text: $form.password)
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }

                    /// TODO: Add website URL
//                    TextField("Website URL (optional)", text: $vaultItem)
//                        .textInputAutocapitalization(.never)
//                        .autocorrectionDisabled()
                }

                Section("Notes") {
                    TextEditor(text: $form.notes)
                        .frame(minHeight: 120)
                }

                Section {
                    Toggle("Favorite", isOn: $form.isFavorite)
                }
            }
            .navigationTitle(form.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(
                            form.title
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .isEmpty
                        )
                }
            }
        }
    }

    private func save() {
        let vaultItem = VaultItemForm(
            id: self.form.id,
            title: self.form.title,
            username: self.form.username,
            password: self.form.password,
            notes: self.form.notes,
            isFavorite: self.form.isFavorite
        )
        
        self.onSave(vaultItem)
        self.dismiss()
    }
}
