//
//  DIContainer.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation

struct DIContainer {
    
    let services: Services
    let session: VaultSession
    
    init(services: Services, session: VaultSession) {
        self.services = services
        self.session = session
    }
}

extension DIContainer {
    struct Services {
        let loginPageService: LoginPageService
        let vaultPageService: VaultPageService
        
        init(loginPageService: LoginPageService, vaultPageService: VaultPageService) {
            self.loginPageService = loginPageService
            self.vaultPageService = vaultPageService
        }
    }
}

