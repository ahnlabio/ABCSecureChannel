/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

public struct Encryption {
    public let origin: String
    public let encrypted: String
    public let channelId: String
}

public struct Decryption {
    public let encrypted: String
    public let decrypted: String
    public let channelId: String
}
