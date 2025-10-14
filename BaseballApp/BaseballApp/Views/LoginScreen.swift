//
//  LoginScreen.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import SwiftUI
import SQLite


struct LoginScreen: SwiftUI.View {
    @State private var username = ""
    @State private var password = ""
    @State private var selectedRole: String? = nil
    @State private var showLoginFields = false
    @State private var loginFailed = false
    @State private var showRoleWarning = false

    var body: some SwiftUI.View {
        NavigationStack {
            ZStack {
                // background
                LinearGradient(colors: [.blue, .purple],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    // title
                    Text("Team Miracle")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    Text("Baseball Performance Tracker")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 20)

                    // coach and player button
                    HStack(spacing: 20) {
                        roleButton(title: "Coach", color: Color.orange)
                        roleButton(title: "Player", color: Color.green)
                    }
                    .padding(.bottom, showLoginFields ? 10 : 80)
                    .animation(.easeInOut(duration: 0.4), value: showLoginFields)

                    // login field
                    if showLoginFields {
                        VStack(spacing: 15) {
                            TextField("Username", text: $username)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 40)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)

                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 40)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)

                            Button("Login as \(selectedRole ?? "")") {
                                login()
                            }
                            .frame(width: 240, height: 44)
                            .background(Color.white.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 10)

                            if loginFailed {
                                Text("Invalid username or password")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                            
                            if showRoleWarning {
                                Text("Please select a role before logging in")
                                    .foregroundColor(.yellow)
                                    .font(.subheadline)
                                    .padding(.top,5)
                            }
                            
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    // making register button always visible below login section
                    NavigationLink(destination: RegisterView()) {
                        Text("Register New Account")
                            .frame(width: 240, height: 44)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, showLoginFields ? 10 : 30)
                            .animation(.easeInOut(duration: 0.4), value: showLoginFields)
                    }

                    Spacer()
                }
                .padding(.top, 50)
            }
            .navigationBarHidden(true)

            // navigation to dashboards
            .navigationDestination(isPresented: Binding(
                get: { selectedRole == "coach_logged_in" },
                set: { _ in selectedRole = nil })
            ) {
                CoachDashboard()
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedRole == "player_logged_in" },
                set: { _ in selectedRole = nil })
            ) {
                PlayerDashboard()
            }
        }
    }

    // role selection button
    private func roleButton(title: String, color: Color) -> some SwiftUI.View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                if selectedRole == title.lowercased() {
                    selectedRole = nil
                    showLoginFields = false
                } else {
                    selectedRole = title.lowercased()
                    showLoginFields = true
                    showRoleWarning = false
                }
            }
        } label: {
            Text(title)
                .font(.headline)
                .frame(width: 140, height: 60)
                .background(selectedRole == title.lowercased()
                            ? color.opacity(0.8)
                            : Color.white.opacity(0.25))
                .foregroundColor(.white)
                .cornerRadius(15)
                .scaleEffect(selectedRole == title.lowercased() ? 1.1 : 1.0)
                .shadow(radius: selectedRole == title.lowercased() ? 8 : 2)
        }
    }

    private func login() {
        guard let roleSelected = selectedRole else {
            showRoleWarning = true
            print("Please select a role before logging in")
            return
        }

        do {
            let users = Table("User")
            let uname = Expression<String>("username")
            let pass = Expression<String>("password")
            let role = Expression<String>("role")
            let usernameExpr = Expression<String>(literal: "'\(username)'")
            let passwordExpr = Expression<String>(literal: "'\(password)'")
            let roleExpr = Expression<String>(literal: "'\(roleSelected)'")

            let query = users
                .filter(uname == usernameExpr)
                .filter(pass == passwordExpr)
                .filter(role == roleExpr)

            if let _ = try DatabaseManager.shared.db.pluck(query) {
                loginFailed = false
                print("\(roleSelected.capitalized) login successful for \(username)")

                if roleSelected == "coach" {
                    selectedRole = "coach_logged_in"
                } else {
                    selectedRole = "player_logged_in"
                }

            } else {
                loginFailed = true
                print("Invalid \(roleSelected) credentials for \(username)")
            }

        } catch {
            loginFailed = true
            print("Login query failed: \(error)")
        }
    }

}
