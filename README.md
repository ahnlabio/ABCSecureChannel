# ABCSecureChannel

ABCSecureChannel for iOS/OS X.

## Model

```swift
public struct Encryption {
    public let origin: String // original message
    public let encrypted: String // encrypted string
    public let channelId: String // shared channel id from server
}

public struct Decryption {
    public let encrypted: String // encrypted message
    public let decrypted: String // decrypted string
    public let channelId: String // shared channel id from server
}
```

## Example

```swift
import ABCSecureChannel

let channelManager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")
channelManager.encrypt(plain: password) { result in
    switch result {
        case .success(let encryption):
            // TODO: use callback Encrypted Model
        case .failure(let error):
            // TODO: handle Error
    }
}

channelManager.decrypt(encrypted: message) { result in
    switch result {
        case .success(let encryption):
            // TODO: use callback Decrypted Model
        case .failure(let error):
            // TODO: handle Error
    }
}

channelManager.channelId() { result in
    switch result {
        case .success(let channelId):
            // ...
        case .failure(let error):
            // TODO: handle Error
    }
}
```

### Swift Combine

```swift
import ABCSecureChannel
import Combine

let channelManager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")

channelManager
    .encrypt(plain: password)
    .flatMap { encryption in
        // TODO: API Call
    }

channelManager
    .decrypt(encrypted: message)
    .map { decryption in
        // TODO: logic
    }

channelManager
    .channelId()
    .flatMap { id in
        // TODO: logic
    }
}
```

### Swift Concurrency

```swift
import ABCSecureChannel

let channelManager = SecureChannelManager(host: "https://dev-api.id.myabcwallet.com")

Task {
    let encryption = try await channelManager.encrypt(plain: password)
    // TODO: API Call ..
    let decryption = try await channelManager.decrypt(encrypted: message)
}
```
