//
//  PBKDF2.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/2/26.
//

import Foundation
import CommonCrypto

enum PBKDF2 {
    /// PBKDF2-HMAC-SHA256 -> returns keyLength bytes (default 32 bytes = 256-bit)
    static func deriveKey(
        password: String,
        salt: Data,
        iterations: Int = 150_000,
        keyLength: Int = 32
    ) throws -> Data {
        precondition(iterations > 0)
        precondition(keyLength > 0)

        var derivedKey = Data(repeating: 0, count: keyLength)

        let passwordData = Data(password.utf8)

        let result: Int32 = derivedKey.withUnsafeMutableBytes { derivedBytes in
            salt.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, passwordData.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress!, salt.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(iterations),
                    derivedBytes.bindMemory(to: UInt8.self).baseAddress!, keyLength
                )
            }
        }

        guard result == kCCSuccess else {
            throw NSError(domain: "PBKDF2", code: Int(result))
        }

        return derivedKey
    }
}
