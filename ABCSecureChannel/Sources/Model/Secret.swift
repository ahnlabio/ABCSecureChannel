/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import CryptoKit

struct Secret {
    let shared: SharedSecret
    let channel: SecureChannel.Response
    var channelId: String { channel.channelId }
}
