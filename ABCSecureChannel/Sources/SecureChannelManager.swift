/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation
import CryptoKit

enum SecureChannelManagerError: Error {
    case invalidChannel
    case selfReleased
}

public final class SecureChannelManager {
    private var current: SecureChannel
    public private(set) var host: URL
    public private(set) var retentionTime: TimeInterval
    
    public init(host: String, retentionTime: TimeInterval = 3600) {
        guard let hostUrl = URL(string: host) else { fatalError("Invalid URL") }
        self.host = hostUrl
        self.retentionTime = retentionTime
        self.current = SecureChannel(host: hostUrl)
    }
    
    public func encrypt(plain: String, completion: @escaping (Result<Encryption, Error>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let encrypted = try secret.shared.encrypt(plain: plain)
                    let encryption = Encryption(origin: plain, encrypted: encrypted, channelId: secret.channelId)
                    
                    completion(.success(encryption))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func decrypt(encrypted: String, completion: @escaping (Result<Decryption, Error>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let decrypted = try secret.shared.decrypt(encrypted: encrypted)
                    let decryption = Decryption(encrypted: encrypted, decrypted: decrypted, channelId: secret.channelId)
                    
                    completion(.success(decryption))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getChannelId(completion: @escaping (Result<String, Error>) -> Void) {
        self.getSecureChannel { result in
            switch result {
            case .success(let channel):
                completion(.success(channel.channelId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getSharedSecret(completion: @escaping (Result<Secret, Error>) -> Void) {
        self.getSecureChannel {[weak self] result in
            guard let this = self else {
                completion(.failure(SecureChannelManagerError.selfReleased))
                return
            }
            
            switch result {
            case .success(let channel):
                do {
                    let sharedSecret = try this.generateValidSharedSecret(
                        encrypted: channel.encrypted,
                        serverPublicKey: channel.publicKey)
                    let secret = Secret(shared: sharedSecret, channel: channel)
                    completion(.success(secret))
                    
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func generateValidSharedSecret(encrypted: String, serverPublicKey: String) throws -> SharedSecret {
        let sharedSecret = try SharedSecret.create(
            privateKey: self.current.privateKey,
            publicKey: serverPublicKey
        )
        
        let decryptedMessage = try sharedSecret.decrypt(encrypted: encrypted)
        if decryptedMessage != self.current.validationMessage {
            throw SecureChannelManagerError.invalidChannel
        }
        return sharedSecret
    }
    
    private func getSecureChannel(completion: @escaping (Result<SecureChannel.Response, Error>) -> Void) {
        if
            let response = self.current.serverResponse,
            self.current.isValid(expired: self.retentionTime) {
            completion(.success(response))
            return
        }
        
        if self.current.serverResponse != nil {
            self.current = SecureChannel(host: self.host)
        }
        
        self.current.create(completion: completion)
    }
}
