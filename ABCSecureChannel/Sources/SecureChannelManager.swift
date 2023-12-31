/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation
import CryptoKit
import ABCUtils

public enum SecureChannelManagerError: Error {
    case invalidChannel
    case selfReleased
    case networkError(error: NetworkError.Response)
    case invalidSharedSecret
    case decryptionError
    case encryptionError
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
    
    public func encrypt(targets: [String: String], completion: @escaping (Result<Encryption<[String: String]>, SecureChannelManagerError>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let result = try targets.mapValues(secret.shared.encrypt)
                    let encryption = Encryption(origin: targets, encrypted: result, channelId: secret.channelId)
                    completion(.success(encryption))
                } catch {
                    completion(.failure(SecureChannelManagerError.encryptionError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func encrypt(plain: String, completion: @escaping (Result<Encryption<String>, SecureChannelManagerError>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let result = try secret.shared.encrypt(plain: plain)
                    let encryption = Encryption(origin: plain, encrypted: result, channelId: secret.channelId)
                    completion(.success(encryption))
                } catch {
                    completion(.failure(SecureChannelManagerError.encryptionError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func decrypt(targets: [String: String], completion: @escaping (Result<Decryption<[String: String]>, SecureChannelManagerError>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let result = try targets.mapValues(secret.shared.decrypt)
                    let decryption = Decryption(encrypted: targets, decrypted: result, channelId: secret.channelId)
                    
                    completion(.success(decryption))
                } catch {
                    completion(.failure(SecureChannelManagerError.decryptionError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func decrypt(encrypted: String, completion: @escaping (Result<Decryption<String>, SecureChannelManagerError>) -> Void) {
        self.getSharedSecret { result in
            switch result {
            case .success(let secret):
                do {
                    let decrypted = try secret.shared.decrypt(encrypted: encrypted)
                    let decryption = Decryption(encrypted: encrypted, decrypted: decrypted, channelId: secret.channelId)
                    
                    completion(.success(decryption))
                } catch {
                    completion(.failure(SecureChannelManagerError.decryptionError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getChannelId(completion: @escaping (Result<String, SecureChannelManagerError>) -> Void) {
        self.getSecureChannel { result in
            switch result {
            case .success(let channel):
                completion(.success(channel.channelId))
            case .failure(let error):
                completion(.failure(SecureChannelManagerError.networkError(error: error)))
            }
        }
    }
    
    private func getSharedSecret(completion: @escaping (Result<Secret, SecureChannelManagerError>) -> Void) {
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
                    completion(.failure(SecureChannelManagerError.invalidSharedSecret))
                }
            case .failure(let error):
                completion(.failure(SecureChannelManagerError.networkError(error: error)))
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
    
    private func getSecureChannel(completion: @escaping (Result<SecureChannel.Response, NetworkError.Response>) -> Void) {
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
