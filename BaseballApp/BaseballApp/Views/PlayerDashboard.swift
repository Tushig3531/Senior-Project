//
//  PlayerDashboard.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import SwiftUI

struct PlayerDashboard: View {
    let user: UserModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Player Dashboard").font(.largeTitle).bold()
                Text("Welcome, \(user.name)")
                Spacer()
            }.padding().navigationTitle("Player")
        }
    }
}
