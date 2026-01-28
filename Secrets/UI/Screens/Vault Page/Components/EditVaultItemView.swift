//
//  EditVaultItemView.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/24/26.
//

import SwiftUI

struct EditVaultItemView: View {
    enum Mode {
        case add
        case edit(VaultItem)

        var title: String { self.isAdd ? "New Secret" : "Edit Secret" }
        var isAdd: Bool {
            if case .add = self { return true }
            return false
        }
        var initial: VaultItem {
            switch self {
            case .add:
                return VaultItem(title: "", username: "", password: "", url: "", notes: "", isFavorite: false)
            case .edit(let item):
                return item
            }
        }
    }

    let mode: Mode
    let onSave: (VaultItem) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var username = ""
    @State private var password = ""
    @State private var url = ""
    @State private var notes = ""
    @State private var isFavorite = false
    @State private var showPassword = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)

                    TextField("Username / Email", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
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

                    TextField("Website URL (optional)", text: $url)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }

                Section {
                    Toggle("Favorite", isOn: $isFavorite)
                }
            }
            .navigationTitle(mode.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                let initial = mode.initial
                title = initial.title
                username = initial.username
                password = initial.password
                url = initial.url
                notes = initial.notes
                isFavorite = initial.isFavorite
            }
        }
    }

    private func save() {
        var base = mode.initial
        base.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        base.username = username
        base.password = password
        base.url = url
        base.notes = notes
        base.isFavorite = isFavorite
        base.updatedAt = Date()

        onSave(base)
        dismiss()
    }
}
