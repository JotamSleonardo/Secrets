//
//  TamSecretsApp.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI

@main
struct SecretsApp: App {
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                VaultPage()
            } else {
                LoginPage(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
