//
//  Crypto.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/6/25.
//

import Foundation
import CryptoKit

enum Crypto{
    static func randomSalt(bytes: Int=16) -> Data {
        var buf = Data(count: bytes)
        _=buf.withUnsafeMutableBytes{SecRandomCopyBytes(kSecRandomDefault, bytes, $0.baseAddress!)}
        return buf
    }
    static func sha256(_ data: Data) -> Data{
        let digest=SHA256.hash(data: data)
        return Data(digest)
    }
    
    static func saltedHash(password: String, salt:Data) -> Data{
        var combined=Data()
        combined.append(salt)
        combined.append(password.data(using: .utf8)!)
        return sha256(combined)
    }
    
    static func toHex(_ data: Data) -> String{
        data.map {String(format: "%02x", $0)}.joined()
    }
    
    static func fromHex(_ hex: String) -> Data {
        var data=Data(capacity: hex.count/2)
        var i=hex.startIndex
        while i<hex.endIndex{
            let j=hex.index(i,offsetBy:2)
            let bytesString=hex[i..<j]
            if let byte=UInt8(bytesString,radix:16){
                data.append(byte)
            }
            i=j
        }
        return data
    }
    
    static func timingSafeEqual(_ a:Data, _ b: Data) -> Bool{
        guard a.count == b.count else {return false}
        var diff: UInt8 = 0
        for i in 0..<a.count {diff |= a[i]^b[i]}
        return diff==0
    }
    
}
