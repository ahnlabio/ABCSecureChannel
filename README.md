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

let url = URL(string: "https://dev-api.id.myabcwallet.com")!
let channelManager = SecureChannelManager(host: url)
channelManager.encrypt(plain: password) { encryption in
    // TODO: use callback Encrypted Model
}

channelManager.decrypt(encrypted: message) { decryption in
    // TODO: use callback Decrypted Model
}

channelManager.channelId() { channelId in
    // ...
}
```

### Swift Combine

```swift
import ABCSecureChannel
import Combine

let url = URL(string: "https://dev-api.id.myabcwallet.com")!
let channelManager = SecureChannelManager(host: url)

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

let url = URL(string: "https://dev-api.id.myabcwallet.com")!
let channelManager = SecureChannelManager(host: url)

Task {
    let encryption = try await channelManager.encrypt(plain: password)
    // TODO: API Call ..
    let decryption = try await channelManager.decrypt(encrypted: message)
}
```
