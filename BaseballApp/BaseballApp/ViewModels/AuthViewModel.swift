//
//  AuthViewModel.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    @Published var statusMessage = ""

    private let db = Firestore.firestore()

    func loadSession() async {
        if let user = Auth.auth().currentUser {
            await fetchUser(uid: user.uid)
        }
    }

    func register(name: String, username: String, email: String, password: String, role: String) async {
        guard !name.isEmpty, !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            statusMessage = "Please fill all fields."
            return
        }
        do {
            let res = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = res.user.uid

           
            let userDoc = UserModel(
                uid: uid,
                username: username,
                name: name,
                email: email,
                role: role,
                team_id: "",
                joined_at: Date(),
                profile_url: nil,
                active: true
            )
            try db.collection("users").document(uid).setData(from: userDoc)

            await fetchUser(uid: uid)
            statusMessage = "Registration successful."
        } catch {
            let nsError = error as NSError
            print("Full Firebase error: \(nsError), code: \(nsError.code)")
            print("UserInfo:", nsError.userInfo)
            statusMessage = "Failed: \(nsError.localizedDescription)"
        }
    }

    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            statusMessage = "Enter email and password."
            return
        }
        do {
            let res = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUser(uid: res.user.uid)
            statusMessage = "Login successful."
        } catch {
            statusMessage = "Login failed: \(error.localizedDescription)"
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
            statusMessage = "Logged out."
        } catch {
            statusMessage = "Logout failed: \(error.localizedDescription)"
        }
    }

    private func fetchUser(uid: String) async {
        do {
            let doc = try await db.collection("users").document(uid).getDocument()
            if let u = try? doc.data(as: UserModel.self) {
                currentUser = u
                isAuthenticated = true
            } else {
                isAuthenticated = false
                statusMessage = "User profile missing."
            }
        } catch {
            isAuthenticated = false
            statusMessage = "Failed to load user: \(error.localizedDescription)"
        }
    }
}

