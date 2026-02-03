//
//  AppEnvironment.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation
import SwiftUI
import SwiftData

struct AppEnvironment {
    let container: DIContainer
    
    static func setUpEnvironment(with context: ModelContext) -> AppEnvironment {
        let session = VaultSession()
        let loginPageRepository: LoginPageRepository = LoginPageRepositoryImpl(
            store: KeychainStore(service: K.keychainServiceKey),
            saltKey: K.saltKey,
            verifierKey: K.verifierKey
        )
        
        let vaultPageRepository: VaultPageRepository = VaultPageRepositoryImpl(
            context: context
        )
        
        let loginPageService: LoginPageService = LoginPageService(repo: loginPageRepository)
        
        let vaultPageService: VaultPageService = VaultPageService(repo: vaultPageRepository)

        let services = DIContainer.Services(
            loginPageService: loginPageService,
            vaultPageService: vaultPageService
        )
        
        let diContainer = DIContainer(services: services, session: session)
        
        return AppEnvironment(container: diContainer)
    }
}
