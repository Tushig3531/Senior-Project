//
//  CoachDashboard.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import SwiftUI

struct CoachDashboard: View {
    let user: UserModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Coach Dashboard").font(.largeTitle).bold()
                Text("Welcome, \(user.name)")
                Text(user.team_id.isEmpty ? "No team assigned" : "Team ID: \(user.team_id)")
                Spacer()
            }.padding().navigationTitle("Coach")
        }
    }
}
