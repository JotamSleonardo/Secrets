//
//  LoginPageVM.swift
//  Secrets
//
//  Created by Jotam Leonardo on 1/28/26.
//

import Foundation
internal import Combine
import SwiftUI

@MainActor
extension LoginPage {
    public final class ViewModel: ObservableObject {
        let container: DIContainer
        
        // View State
        @Published var masterPassword = ""
        @Published var createdPassword = ""
        @Published var errorMessage: String?
        @Published var isLoading = false
        @Published var isCreatingAccount = false
        
        init(container: DIContainer) {
            self.container = container
        }
        
        public func createVault() {
            errorMessage = nil
            isLoading = true
            
            // Simulate local verification delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] () -> Void in
                guard let self else { return }
                do {
                    try self.container
                        .services
                        .loginPageService
                        .registerMaster(
                            password: self.createdPassword,
                            confirm: self.masterPassword
                        )
                    self.clear()
                    self.isCreatingAccount = false
                } catch AuthError.tooShort {
                    self.errorMessage = "Use at least 8 characters."
                } catch AuthError.notMatch {
                    self.errorMessage = "Passwords do not match."
                } catch {
                    self.errorMessage = "Something went wrong."
                }
            }
            
        }
        
        public func unlockVault() {
            errorMessage = nil
            isLoading = true

            Task {
                try? await Task.sleep(for: .seconds(1.5))
                do {
                    let key = try await self.container
                        .services
                        .loginPageService
                        .unlock(password: self.masterPassword)

                    self.container.session.unlock(with: key)
                } catch AuthError.wrongPassword {
                    self.errorMessage = K.invalidPassword
                } catch {
                    self.errorMessage = "Something went wrong."
                }
                self.isLoading = false
            }
        }
        
        public func clear() {
            masterPassword = ""
            createdPassword = ""
            errorMessage = nil
        }
    }
}
