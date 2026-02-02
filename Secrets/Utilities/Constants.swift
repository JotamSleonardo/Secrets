//
//  Constants.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

public enum K {
    public static let appName: String = "Secrets"
    
    /// Static Strings
    public static let appFootNote: String = "That no one should know"
    public static let createPassPlaceHolder: String = "Enter Master Passowrd"
    public static let confirmPassPlaceHolder: String = "Confirm Master Password"
    public static let masterPassPlaceHolder: String = "Master Password"
    public static let createVaultText: String = "Create Vault"
    public static let unlockVaultText: String = "Unlock Vault"
    public static let existingVaultText: String = "Already have a Vault?"
    public static let vaultCreatedText: String = "Vault created successfully!"
    public static let invalidPassword: String = "Invalid master password"
    public static let invalidMatchPassword: String = "Passwords do not match."
    
    /// App Keys
    public static let keychainServiceKey: String = "com.passwordvault.keychain"
    public static let saltKey: String = "master_salt"
    public static let verifierKey: String = "master_verifier"
    
    public static let samplePassword: String = "123"

}
