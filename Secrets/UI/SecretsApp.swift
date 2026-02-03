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

    private let modelContainer: ModelContainer = {
        try! ModelContainer(for: VaultItem.self)
    }()
    private var modelContext: ModelContext { modelContainer.mainContext }
    private var container: DIContainer { AppEnvironment.setUpEnvironment(with: modelContext).container }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                VaultPage(viewModel: .init(container: container))
            } else {
                LoginPage(
                    viewModel: .init(container: container),
                    isLoggedIn: $isLoggedIn
                )
            }
        }.modelContainer(for: VaultItem.self)
    }
}
