//
//  ContentView.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI

struct LoginPage: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // App Icon / Title
            VStack(spacing: 8) {
                Image("shield")
                    .resizable()
                    .frame(width: 80, height: 80)

                Text(K.appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(K.appFootNote)
                    .foregroundColor(.secondary)
            }
            
            // Master Password Field
            VStack(spacing: 12) {
                if viewModel.isCreatingAccount {
                    PasswordField(placeHolder: K.createPassPlaceHolder, password: $viewModel.createdPassword)
                    PasswordField(placeHolder: K.confirmPassPlaceHolder, password: $viewModel.masterPassword)
                } else {
                    PasswordField(placeHolder: K.masterPassPlaceHolder, password: $viewModel.masterPassword)
                }
                
                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }

            // Login Button
            Button {
                if viewModel.isCreatingAccount {
                    viewModel.createVault()
                } else {
                    viewModel.unlockVault()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(viewModel.isCreatingAccount ? K.createVaultText : K.unlockVaultText)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 60.0)
            .background(viewModel.masterPassword.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(viewModel.masterPassword.isEmpty || viewModel.isLoading)
            
            Button(viewModel.isCreatingAccount ? K.existingVaultText : K.createVaultText) {
                viewModel.isCreatingAccount = !viewModel.isCreatingAccount
                viewModel.clear()
            }
            .fontWeight(.heavy)
            .font(.caption)

            Spacer()
        }
        .padding()
    }
}
