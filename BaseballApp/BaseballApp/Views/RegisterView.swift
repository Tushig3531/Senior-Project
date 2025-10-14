//
//  RegisterView.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole: String? = nil
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var showRoleWarning = false

    var body: some View {
        ZStack {
            // background
            LinearGradient(colors: [.blue, .purple],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                // input fields
                Group {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // picking role
                Picker("Role", selection: $selectedRole) {
                    Text("Coach").tag("coach")
                    Text("Player").tag("player")
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
                .padding(.vertical, 44)

                // register button
                Button("Register") {
                    registerUser()
                }
                .frame(width: 220, height: 44)
                .background(Color.white.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)
                
                if showRoleWarning {
                    Text("Please select a role before registering")
                        .foregroundColor(.yellow)
                        .font(.subheadline)}
                
                // success
                if showSuccess {
                    Text("Registration Successful")
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        }
                }

                if !errorMessage.isEmpty {
                    Text("\(errorMessage)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .transition(.opacity)
                }

                Spacer()

                // back button
                Button("← Back to Login") {
                    dismiss()
                }
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 20)
            }
            .padding(.top, 60)
            .animation(.easeInOut, value: showSuccess)
        }
    }

    // registration logic
    private func registerUser() {
            guard !name.isEmpty,
                  !username.isEmpty,
                  !email.isEmpty,
                  !password.isEmpty else {
                errorMessage = "All fields are required"
                showSuccess = false
                showRoleWarning = false
                return
            }

            guard let roleSelected = selectedRole else {
                showRoleWarning = true
                errorMessage = ""
                showSuccess = false
                print("Please select a role before registering")
                return
            }

            let uid = UUID().uuidString

            DatabaseManager.shared.insertUser(
                uid: uid,
                name: name,
                username: username,
                email: email,
                password: password,
                role: roleSelected
            )
            showSuccess = true
            showRoleWarning = false
            errorMessage = ""
            print("New \(roleSelected) registered: \(username)")
        }
}
