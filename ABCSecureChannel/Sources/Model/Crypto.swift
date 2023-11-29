/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

public struct Encryption<T> {
    public let origin: T
    public let encrypted: T
    public let channelId: String
}

public struct Decryption<T> {
    public let encrypted: T
    public let decrypted: T
    public let channelId: String
}
