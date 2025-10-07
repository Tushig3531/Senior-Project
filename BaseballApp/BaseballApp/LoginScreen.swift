import SwiftUI
import SwiftData

struct LoginScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var auth = AuthViewModel()

    @State private var showCoachLogin = false
    @State private var showTeamLogin = false

    @State private var coachUsername = ""
    @State private var coachPassword = ""
    @State private var teamUsername = ""
    @State private var teamPassword = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.30, blue: 0.55),
                        Color(red: 0.65, green: 0.90, blue: 0.55),
                        Color(red: 0.90, green: 0.85, blue: 0.70)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                LinearGradient(
                    colors: [.white.opacity(0.1), .black.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.overlay)
                .ignoresSafeArea()

                VStack(alignment: .center, spacing: 25) {
                    VStack(spacing: 6) {
                        Text("Team Miracle")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)

                        Text("Baseball Performance Tracker")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 30)

                    // Coach login button & form
                    Button(action: toggleCoachLogin) {
                        Text("Coach")
                            .font(.headline)
                            .frame(width: 260, height: 50)
                            .background(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }

                    if showCoachLogin {
                        VStack(spacing: 12) {
                            TextField("Coach Username", text: $coachUsername)
                                .padding()
                                .frame(width: 260)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()

                            SecureField("Password", text: $coachPassword)
                                .padding()
                                .frame(width: 260)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)

                            Button {
                                auth.login(username: coachUsername, password: coachPassword, modelContext: modelContext)
                            } label: {
                                Text("Login")
                                    .font(.headline)
                                    .frame(width: 180, height: 45)
                                    .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.4), value: showCoachLogin)
                    }

                    // Team login button & form
                    Button(action: toggleTeamLogin) {
                        Text("Team Member")
                            .font(.headline)
                            .frame(width: 260, height: 50)
                            .background(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }

                    if showTeamLogin {
                        VStack(spacing: 12) {
                            TextField("Team Member Username", text: $teamUsername)
                                .padding()
                                .frame(width: 260)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()

                            SecureField("Password", text: $teamPassword)
                                .padding()
                                .frame(width: 260)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)

                            Button {
                                auth.login(username: teamUsername, password: teamPassword, modelContext: modelContext)
                            } label: {
                                Text("Login")
                                    .font(.headline)
                                    .frame(width: 180, height: 45)
                                    .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.4), value: showTeamLogin)
                    }

                    // Register
                    NavigationLink(value: "register") {
                        Text("Register")
                            .font(.subheadline)
                            .frame(width: 180, height: 35)
                            .background(Color.gray.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                    .padding(.top, 20)

                    // Status
                    if !auth.statusMessage.isEmpty {
                        Text(auth.statusMessage)
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.top, 4)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
            }
            .navigationDestination(for: String.self) { route in
                if route == "register" { RegisterView() }
            }
            .onAppear { auth.loadSession() }
        }
    }

    // MARK: - Toggles
    private func toggleCoachLogin() {
        withAnimation(.easeInOut(duration: 0.4)) {
            showCoachLogin.toggle()
            if showCoachLogin { showTeamLogin = false }
        }
    }

    private func toggleTeamLogin() {
        withAnimation(.easeInOut(duration: 0.4)) {
            showTeamLogin.toggle()
            if showTeamLogin { showCoachLogin = false }
        }
    }
}
