//
//  Extensions.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/2/26.
//

import Foundation
import CryptoKit

extension Data {
    func decrypt(using key: SymmetricKey) throws -> String {
        let box = try AES.GCM.SealedBox(combined: self)
        let decrypted = try AES.GCM.open(box, using: key)
        
        return String(decoding: decrypted, as: UTF8.self)
    }
    
}

extension String {
    func encrypt(using key: SymmetricKey) throws -> Data {
        let data = Data(self.utf8)
        let sealed = try AES.GCM.seal(data, using: key)
        
        guard let combined = sealed.combined else {
            throw NSError(domain: "VaultCrypto", code: 1)
        }

        return combined
    }
}

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
