//
//  DIContainer.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation

struct DIContainer {
    
    let services: Services
    
    init(services: Services) {
        self.services = services
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

