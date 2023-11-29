/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation
import CryptoKit
import CryptoSwift

extension SharedSecret {
    
    static func create(privateKey: P256.KeyAgreement.PrivateKey, publicKey: String) throws -> SharedSecret{

        var serverKey = publicKey
        let startIndex = serverKey.index(serverKey.startIndex, offsetBy: 2)
        serverKey = String(serverKey[startIndex...])
        
        let publicKeyFromServer = try P256.KeyAgreement.PublicKey(rawRepresentation: Data(hex: serverKey))
        return try privateKey.sharedSecretFromKeyAgreement(with: publicKeyFromServer)
    }
    
    private func getCipher() throws -> Cipher {
        try self.withUnsafeBytes { bytes in
            let keyBytes = bytes[..<16]
            let ivBytes = bytes[16...]
            return try AES(key: Array(keyBytes), blockMode: CBC(iv: Array(ivBytes)))
        }
    }
    
    func encrypt(plain: String) throws -> String {
        let aes = try getCipher()
        let encryptedBytes = try aes.encrypt(plain.bytes)
        return encryptedBytes.toBase64()
    }
        
    func decrypt(encrypted: String) throws -> String {
        guard
            let base64Decoded = Data(base64Encoded: encrypted) else {
            throw CryptoError.decodeError
        }
        
        let aes = try getCipher()
        let decryptedData = try aes.decrypt(base64Decoded.bytes)
        if let decryptedString = String(bytes: decryptedData, encoding: .utf8) {
            return decryptedString
        }
        throw CryptoError.decryptError
    }
}

extension SharedSecret {
    enum CryptoError: Error {
        case decryptError
        case decodeError
    }
}
