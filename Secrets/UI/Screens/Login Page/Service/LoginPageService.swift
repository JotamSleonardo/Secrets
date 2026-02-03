//
//  KeychainService.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation
import Security
import CryptoKit

enum AuthError: Error {
    case tooShort
    case notMatch
    case masterNotSet
    case wrongPassword
}

protocol LoginPageType {
    func masterExists() -> Bool
    func registerMaster(password: String, confirm: String) throws
    func unlock(password: String) async throws -> SymmetricKey
}

struct LoginPageService: LoginPageType {
    let repo: LoginPageRepository
    
    func masterExists() -> Bool {
        self.repo.masterExists()
    }
    
    func registerMaster(password: String, confirm: String) throws {
        guard password.count >= 8 else { throw AuthError.tooShort }
        guard password == confirm else { throw AuthError.notMatch }

        // 1) salt
        let salt = Data((0..<16).map { _ in UInt8.random(in: 0...255) })

        // 2) derive key (CommonCrypto)
        let key = try PBKDF2.deriveKey(password: password, salt: salt)
        
        // 3) verifier
        let verifier = Data(SHA256.hash(data: key))

        // 4) save
        try repo.saveMaster(salt: salt, verifier: verifier)
    }
    
    func unlock(password: String) async throws -> SymmetricKey {
        try await Task.detached(priority: .userInitiated) {
            guard let master = try await repo.loadMaster() else { throw AuthError.masterNotSet }
            
            let key = try await PBKDF2.deriveKey(password: password, salt: master.salt)
            let verifier = Data(SHA256.hash(data: key))
            guard verifier == master.verifier else { throw AuthError.wrongPassword }
            
            return SymmetricKey(data: key)
        }.value
    }
}
