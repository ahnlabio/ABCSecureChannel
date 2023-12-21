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
import ABCUtils

final class SecureChannel {
    public let host: URL
    public let privateKey = P256.KeyAgreement.PrivateKey()
    public var publicKey: P256.KeyAgreement.PublicKey { privateKey.publicKey }
    
    private let randomString = UUID().uuidString
    
    public var validationMessage: String { randomString }
    
    public var serverResponse: Response?
    public var createdAt: TimeInterval?
    
    
    init(host: URL) {
        self.host = host
    }
    
    func isValid(expired: TimeInterval) -> Bool {
        let hasServerResponse = self.serverResponse != nil
        let issuedAt = self.createdAt ?? 0
        let isNotExpired = expired > (Date().timeIntervalSince1970 - issuedAt)
        return hasServerResponse && isNotExpired
    }
    
    func create(completion: @escaping (Result<SecureChannel.Response, NetworkError.Response>) -> Void) {
        self._create { [weak self] result in
            switch result {
            case .success(let response):
                self?.serverResponse = response
                self?.createdAt = Date().timeIntervalSince1970
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func _create(completion: @escaping (Result<SecureChannel.Response, NetworkError.Response>) -> Void) {
        
        let components = URLComponents(
            host: self.host,
            path: "/secure/channel/create")
        
        let request = URLRequest(
            url: components?.url,
            method: .post,
            body: [
                "pubkey": "04\(self.publicKey.rawRepresentation.toHexString())",
                "plain": self.validationMessage
            ]
        )
        
        URLSession.shared.invoke(with: request, completion: completion)
        
    }
}


extension SecureChannel {
    struct Response: Decodable {
        let channelId: String
        let publicKey: String
        let encrypted: String
        
        enum CodingKeys: String, CodingKey {
            case channelId = "channelid"
            case publicKey = "publickey"
            case encrypted
        }
    }
}
