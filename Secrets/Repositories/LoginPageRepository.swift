//
//  LoginPageRepository.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation

protocol LoginPageRepository {
    func masterExists() -> Bool
    func saveMaster(salt: Data, verifier: Data) throws
    func loadMaster() throws -> (salt: Data, verifier: Data)?
}

struct LoginPageRepositoryImpl: LoginPageRepository {
    let store: KeychainStore
    let saltKey: String
    let verifierKey: String
    
    init(store: KeychainStore, saltKey: String, verifierKey: String) {
        self.store = store
        self.saltKey = saltKey
        self.verifierKey = verifierKey
    }
    
    func masterExists() -> Bool {
        (try? store.load(account: saltKey)) != nil && (try? store.load(account: verifierKey)) != nil
    }
    
    func saveMaster(salt: Data, verifier: Data) throws {
        try store.save(account: saltKey, data: salt)
        try store.save(account: verifierKey, data: verifier)
    }
    
    func loadMaster() throws -> (salt: Data, verifier: Data)? {
        guard
            let salt = try store.load(account: saltKey),
            let verifier = try store.load(account: verifierKey)
        else { return nil }
        return (salt, verifier)
    }
}
