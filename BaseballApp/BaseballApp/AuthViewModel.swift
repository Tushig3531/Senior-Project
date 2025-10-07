//
//  AuthViewModel.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/6/25.
//
import Foundation
import SwiftData
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var statusMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var currentUsername: String = ""

    private let sessionKey = "team.miracle.currentUser"

    func loadSession() {
        if let u = KeychainHelper.getString(for: sessionKey) {
            isAuthenticated = true
            currentUsername = u
        }
    }

    func logout() {
        KeychainHelper.remove(for: sessionKey)
        isAuthenticated = false
        currentUsername = ""
        statusMessage = "Logged out."
    }

    func register(name: String, username: String, password: String, modelContext: ModelContext) {
        guard !name.isEmpty, !username.isEmpty, !password.isEmpty else {
            statusMessage = "Please fill all fields."
            return
        }

        // Check username uniqueness
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.username == username })
        if let existing = try? modelContext.fetch(descriptor), !existing.isEmpty {
            statusMessage = "Username already exists."
            return
        }

        // Create salted hash
        let salt = Crypto.randomSalt()
        let hash = Crypto.saltedHash(password: password, salt: salt)

        let user = User(
            name: name,
            username: username,
            passwordHashHex: Crypto.toHex(hash),
            saltHex: Crypto.toHex(salt)
        )

        do {
            modelContext.insert(user)
            try modelContext.save()
            statusMessage = "Registration successful."
        } catch {
            statusMessage = "Failed to save user: \(error.localizedDescription)"
        }
    }

    func login(username: String, password: String, modelContext: ModelContext) {
        guard !username.isEmpty, !password.isEmpty else {
            statusMessage = "Enter username and password."
            return
        }

        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.username == username })
        guard let found = try? modelContext.fetch(descriptor).first else {
            statusMessage = "Invalid username or password."
            isAuthenticated = false
            return
        }

        let salt = Crypto.fromHex(found.saltHex)
        let attemptHash = Crypto.saltedHash(password: password, salt: salt)
        let stored = Crypto.fromHex(found.passwordHashHex)

        if Crypto.timingSafeEqual(stored, attemptHash) {
            isAuthenticated = true
            currentUsername = found.username
            statusMessage = "Login successful."
            KeychainHelper.setString(found.username, for: sessionKey)
        } else {
            isAuthenticated = false
            statusMessage = "Invalid username or password."
        }
    }
}
