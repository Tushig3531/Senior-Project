//
//  BaseballAppApp.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//

import SwiftUI
import FirebaseCore

@main
struct BaseballAppApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginScreen()
        }
    }
}
