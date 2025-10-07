//
//  Models.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/6/25.
//
import Foundation
import SwiftData

@Model
final class User{
    @Attribute(.unique) var username: String
    var name:String
    var passwordHashHex: String
    var saltHex: String
    var createdAt: Date
    
    init(name: String, username: String, passwordHashHex: String, saltHex:String){
        self.name=name
        self.username = username
        self.passwordHashHex = passwordHashHex
        self.saltHex = saltHex
        self.createdAt = Date()
    }
}




