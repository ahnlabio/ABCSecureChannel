/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Combine
import Foundation

extension SecureChannelManager {
    public func getChannelId() async throws -> String {
        try await withCheckedThrowingContinuation {
            getChannelId(completion: $0.resume)
        }
    }
    
    public func encrypt(plain: String) async throws -> Encryption<String> {
        try await withCheckedThrowingContinuation {
            encrypt(plain: plain, completion: $0.resume)
        }
    }
    
    public func decrypt(encrypted: String) async throws -> Decryption<String> {
        try await withCheckedThrowingContinuation {
            decrypt(encrypted: encrypted, completion: $0.resume)
        }
    }
    
    public func encrypt(targets: [String: String]) async throws -> Encryption<[String: String]> {
        try await withCheckedThrowingContinuation {
            encrypt(targets: targets, completion: $0.resume)
        }
    }
    
    public func decrypt(targets: [String: String]) async throws -> Decryption<[String: String]> {
        try await withCheckedThrowingContinuation {
            decrypt(targets: targets, completion: $0.resume)
        }
    }
}

extension SecureChannelManager {
    
    public func getChannelId() -> AnyPublisher<String, SecureChannelManagerError> {
        Deferred {
            Future {
                self.getChannelId(completion: $0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func encrypt(plain: String) -> AnyPublisher<Encryption<String>, SecureChannelManagerError> {
        Deferred {
            Future {
                self.encrypt(plain: plain, completion: $0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func encrypt(targets: [String: String]) -> AnyPublisher<Encryption<[String: String]>, SecureChannelManagerError> {
        Deferred {
            Future {
                self.encrypt(targets: targets, completion: $0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func decrypt(encrypted: String) -> AnyPublisher<Decryption<String>, SecureChannelManagerError> {
        Deferred {
            Future {
                self.decrypt(encrypted: encrypted, completion: $0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func decrypt(targets: [String: String]) -> AnyPublisher<Decryption<[String: String]>, SecureChannelManagerError> {
        Deferred {
            Future {
                self.decrypt(targets: targets, completion: $0)
            }
        }
        .eraseToAnyPublisher()
    }
}
