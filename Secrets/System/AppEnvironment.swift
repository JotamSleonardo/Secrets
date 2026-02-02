//
//  AppEnvironment.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
    
    static func setUpEnvironment() -> AppEnvironment {
        let loginPageRepository: LoginPageRepository = LoginPageRepositoryImpl(
            store: KeychainStore(service: K.keychainServiceKey),
            saltKey: K.saltKey,
            verifierKey: K.verifierKey
        )
        
        let loginPageService: LoginPageService = LoginPageService(repo: loginPageRepository)

        let services = DIContainer.Services(
            loginPageService: loginPageService
        )
        
        let diContainer = DIContainer(services: services)
        
        return AppEnvironment(container: diContainer)
    }
}
