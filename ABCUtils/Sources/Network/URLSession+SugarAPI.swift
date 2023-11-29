/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

extension URLSession {
    
    public func dataTask(with request: URLRequest?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        guard let request = request else {
            completion(nil, nil, NetworkError.Request.requestURLError(urlString: request?.url?.absoluteString ?? "unknown"))
            return nil
        }
        return self.dataTask(with: request, completionHandler: completion)
    }
}
