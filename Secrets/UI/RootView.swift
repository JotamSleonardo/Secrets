//
//  RootView.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/3/26.
//
import SwiftUI

struct RootView: View {
    let container: DIContainer
    @EnvironmentObject var session: VaultSession

    var body: some View {
        Group {
            if session.isUnlocked {
                VaultPage(viewModel: .init(container: container))
            } else {
                LoginPage(viewModel: .init(container: container))
            }
        }
    }
}
