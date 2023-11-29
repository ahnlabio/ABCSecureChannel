/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

extension URLComponents {
    
    public init?(host: URL, path: String = "", queries: [String: Any]? = nil) {
        self.init(string: "\(host.absoluteString)\(path)", queries: queries)
    }
    
    public init?(string: String, queries: [String: Any]? = nil) {
        self.init(string: string)
        self.queryItems = queries?.map { item in
            URLQueryItem(name: item.key, value: item.value as? String)
        }
    }
}
