//
//  TamSecretsApp.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI
import SwiftData

@main
struct SecretsApp: App {
    @State private var isLoggedIn = false
    private let container = AppEnvironment.setUpEnvironment().container
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                VaultPage()
            } else {
                LoginPage(
                    viewModel: .init(container: container),
                    isLoggedIn: $isLoggedIn
                )
            }
        }.modelContainer(for: VaultItem.self)
    }
}
