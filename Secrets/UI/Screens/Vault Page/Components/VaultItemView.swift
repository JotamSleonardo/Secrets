//
//  VaultRow.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI

public struct VaultItemView: View {
    let item: VaultItemDTO
    @State private var revealPassword = false

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 44, height: 44)
                Image(systemName: item.isFavorite ? "star.fill" : "key.fill")
                    .foregroundColor(item.isFavorite ? .yellow : .blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.headline)

                    if item.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }

                if !item.username.isEmpty {
                    Text(item.username)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    Text(revealPassword ? item.password : "••••••••")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Button {
                        revealPassword.toggle()
                    } label: {
                        Image(systemName: revealPassword ? "eye.slash" : "eye")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            Menu {
                if !item.username.isEmpty {
                    Button {
                        UIPasteboard.general.string = item.username
                    } label: {
                        Label("Copy Username", systemImage: "doc.on.doc")
                    }
                }

                if !item.password.isEmpty {
                    Button {
                        UIPasteboard.general.string = item.password
                    } label: {
                        Label("Copy Password", systemImage: "doc.on.doc")
                    }
                }

                /// TODO: Add url
//                if !item.url.isEmpty {
//                    Button {
//                        if let url = URL(string: item.url) {
//                            UIApplication.shared.open(url)
//                        }
//                    } label: {
//                        Label("Open Website", systemImage: "safari")
//                    }
//                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
            }
        }
        .padding(.vertical, 6)
    }
}
