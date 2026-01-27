//
//  ContentView.swift
//  TamSecrets
//
//  Created by Jotam Leonardo on 1/23/26.
//

import SwiftUI

struct LoginPage: View {
    @Binding public var isLoggedIn: Bool
    @State private var masterPassword = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // App Icon / Title
            VStack(spacing: 8) {
                Image("shield")
                    .resizable()
                    .frame(width: 80, height: 80)

                Text("Tam Secrets")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Enter your master password")
                    .foregroundColor(.secondary)
            }

            // Password Field
            VStack(spacing: 12) {
                HStack {
                    Group {
                        if showPassword {
                            TextField("Master Password", text: $masterPassword)
                        } else {
                            SecureField("Master Password", text: $masterPassword)
                        }
                    }
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .disableAutocorrection(true)

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // Login Button
            Button {
                login()
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Unlock Vault")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(width: 250.0, height: 60.0)
            .background(masterPassword.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(masterPassword.isEmpty || isLoading)

            Spacer()
        }
        .padding()
    }

    // MARK: - Login Logic
    private func login() {
        self.errorMessage = nil
        self.isLoading = true

        // Simulate local verification delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if masterPassword == "123" {
                self.isLoading = false
                self.isLoggedIn = true
            } else {
                self.isLoading = false
                self.errorMessage = "Invalid master password"
            }
        }
    }
}
