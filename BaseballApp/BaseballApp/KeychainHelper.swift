
//
//  KeychainHelper.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/6/25.
//

import Foundation
import Security

enum KeychainHelper{
    static func set(_ value: Data, for key: String){
        let query: [String: Any]=[
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)}
            
            
    static func get(for key: String) -> Data?{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var out: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &out)
        return out as? Data
    }
    
    static func setString(_ s: String, for key: String){
        set(Data(s.utf8), for:key)
    }
    
    static func getString(for key: String) -> String? {
        guard let d = get(for: key) else { return nil }
        return String(data: d, encoding: .utf8)
        }
    
    static func remove(for key: String){
        let q: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: key]
        SecItemDelete(q as CFDictionary)
    }
    
}
