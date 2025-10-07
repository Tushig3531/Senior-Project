//
//  RegisterView.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/6/25.
//
import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var auth = AuthViewModel()
    
    @State private var name=""
    @State private var username=""
    @State private var password=""
    
    var body: some View{
        VStack(spacing: 18){
            Text("Create Account")
                .font(.title).bold()
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .padding(.horizontal)
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            Button{
                auth.register(name: name, username: username, password: password, modelContext: modelContext)
            } label:{
                Text("Register")
                    .frame(width: 200, height: 44)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
            Text(auth.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top,6)
            Spacer()
        }
            .padding(.top,24)
    }
}
    
