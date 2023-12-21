/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import XCTest
@testable import ABCSecureChannel

final class SecureChannelTests: XCTestCase {
        
    func testCreateSecureChannel() {
        let expectCreateSession = expectation(description: "Create Channel")
        
        let channel = SecureChannel(host: URL(string: "https://dev-api.id.myabcwallet.com")!)
        channel.create { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectCreateSession.fulfill()
        }
        wait(for: [expectCreateSession])
    }
    
    func testCreateSecureChannelManager() {
        let expectCreateSession = expectation(description: "Encrypt Message")
        
        let manager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")
        manager.encrypt(plain: "Hello world") { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectCreateSession.fulfill()
        }
        
        wait(for: [expectCreateSession])
    }
    
    func testEncryptMultipleValues() {
        let expectCreateSession = expectation(description: "Encrypt Message")
        
        let targets = [
            "password": "Hello",
            "key": "World"
        ]
        let manager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")
        manager.encrypt(targets: targets) { result in
            switch result {
            case .success(let encryption):
                XCTAssertNotNil(encryption.encrypted["password"])
                XCTAssertNotNil(encryption.encrypted["key"])
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectCreateSession.fulfill()
        }
        
        wait(for: [expectCreateSession])
    }
    
    func testEncryptMultipleValues() async throws {        
        let targets = [
            "password": "Hello",
            "key": "World"
        ]
        let manager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")
        let encrypted = try await manager.encrypt(targets: targets)
        XCTAssertNotNil(encrypted.encrypted["password"])
        XCTAssertNotNil(encrypted.encrypted["key"])
    }
}
