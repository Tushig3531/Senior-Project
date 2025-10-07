//
//  HelloWorld.swift
//
//
//  Created by Tushig Erdenebulgan on 10/1/25.
//
import SwiftUI
import SwiftData

@main
struct BaseballAppApp: App{
    var sharedContainer: ModelContainer = {
        let projectURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("team_miracle_data.store")

        let config = ModelConfiguration(url: projectURL)

        return try! ModelContainer(for: User.self, configurations: config)
        }()
        
        var body: some Scene {
            WindowGroup {
                LoginScreen()
                    .modelContainer(sharedContainer)
            }
        }
    }

