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
    private let modelContainer: ModelContainer
    private let container: DIContainer
    
    init() {
        self.modelContainer = try! ModelContainer(for: VaultItem.self)
        self.container = AppEnvironment.setUpEnvironment(
            with: self.modelContainer.mainContext
        ).container
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(container: container)
                .environmentObject(container.session)
        }
        .modelContainer(modelContainer)
    }
}
