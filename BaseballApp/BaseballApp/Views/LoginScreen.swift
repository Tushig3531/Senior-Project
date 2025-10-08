//
//  LoginScreen.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import SwiftUI

struct LoginScreen: View {
    @StateObject private var auth = AuthViewModel()
    @State private var showCoachLogin = false
    @State private var showTeamLogin = false
    @State private var coachEmail = ""
    @State private var coachPassword = ""
    @State private var teamEmail = ""
    @State private var teamPassword = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red:0.15,green:0.30,blue:0.55),
                                        Color(red:0.65,green:0.90,blue:0.55),
                                        Color(red:0.90,green:0.85,blue:0.70)],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

                VStack(spacing: 25) {
                    VStack(spacing: 6) {
                        Text("Team Miracle")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text("Baseball Performance Tracker")
                            .font(.subheadline).foregroundColor(.white.opacity(0.9))
                    }.padding(.top, 60).padding(.bottom, 30)

                    Button(action: { withAnimation { showCoachLogin.toggle(); if showCoachLogin { showTeamLogin = false } } }) {
                        Text("Coach").font(.headline)
                            .frame(width: 260, height: 50)
                            .background(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white).cornerRadius(12).shadow(radius: 4)
                    }

                    if showCoachLogin {
                        VStack(spacing: 12) {
                            TextField("Coach Email", text: $coachEmail)
                                .textInputAutocapitalization(.never).autocorrectionDisabled()
                                .padding().frame(width: 260).background(.ultraThinMaterial).cornerRadius(10)
                            SecureField("Password", text: $coachPassword)
                                .padding().frame(width: 260).background(.ultraThinMaterial).cornerRadius(10)
                            Button { Task { await auth.login(email: coachEmail, password: coachPassword) } } label: {
                                Text("Login").font(.headline)
                                    .frame(width: 180, height: 45)
                                    .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white).cornerRadius(10).shadow(radius: 3)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    Button(action: { withAnimation { showTeamLogin.toggle(); if showTeamLogin { showCoachLogin = false } } }) {
                        Text("Team Member").font(.headline)
                            .frame(width: 260, height: 50)
                            .background(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white).cornerRadius(12).shadow(radius: 4)
                    }

                    if showTeamLogin {
                        VStack(spacing: 12) {
                            TextField("Player Email", text: $teamEmail)
                                .textInputAutocapitalization(.never).autocorrectionDisabled()
                                .padding().frame(width: 260).background(.ultraThinMaterial).cornerRadius(10)
                            SecureField("Password", text: $teamPassword)
                                .padding().frame(width: 260).background(.ultraThinMaterial).cornerRadius(10)
                            Button { Task { await auth.login(email: teamEmail, password: teamPassword) } } label: {
                                Text("Login").font(.headline)
                                    .frame(width: 180, height: 45)
                                    .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white).cornerRadius(10).shadow(radius: 3)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    NavigationLink(destination: RegisterView()) {
                        Text("Register").font(.subheadline)
                            .frame(width: 180, height: 35)
                            .background(Color.gray.opacity(0.9)).foregroundColor(.white)
                            .cornerRadius(8).shadow(radius: 3)
                    }.padding(.top, 20)

                    if !auth.statusMessage.isEmpty {
                        Text(auth.statusMessage).font(.footnote)
                            .foregroundStyle(.white.opacity(0.9)).padding(.top, 4)
                    }

                    if auth.isAuthenticated, let u = auth.currentUser {
                        NavigationLink(destination: u.role == "coach"
                                       ? AnyView(CoachDashboard(user: u))
                                       : AnyView(PlayerDashboard(user: u))) {
                            Text("Continue")
                                .frame(width: 200, height: 44)
                                .background(.white.opacity(0.2))
                                .foregroundColor(.white).cornerRadius(10)
                        }.padding(.top, 10)
                    }
                    Spacer()
                }
            }
            .task { await auth.loadSession() }
        }
    }
}
