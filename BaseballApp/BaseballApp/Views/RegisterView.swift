//
//  RegisterView.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var auth = AuthViewModel()

    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "player"   // "coach" | "player"

    var body: some View {
        VStack(spacing: 18) {
            Text("Create Account")
                .font(.title).bold()

            // Name
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .padding(.horizontal)

            // Username
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal)

            // Email
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            // Password
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            // Role picker (matches your schema's "role")
            Picker("Role", selection: $selectedRole) {
                Text("Coach").tag("coach")
                Text("Player").tag("player")
            }
            .pickerStyle(.segmented)
            .frame(width: 220)

            // Register button (writes to /users/{uid} in Firestore)
            Button {
                Task {
                    await auth.register(
                        name: name,
                        username: username,
                        email: email,
                        password: password,
                        role: selectedRole
                    )
                }
            } label: {
                Text("Register")
                    .frame(width: 200, height: 44)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }

            // Status text
            if !auth.statusMessage.isEmpty {
                Text(auth.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 24)
    }
}
