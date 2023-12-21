/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

public enum NetworkError {
    public enum Request: Error {
        case requestURLError(urlString: String)
    }
    
    public enum Response: LocalizedError {
        case urlError(url: String?)
        case serverError(Error)
        case invalidHttpResponse
        case emptyData
        case statusCodeError(status: Int, origin: String?, error: ABCNetworkError?)
        case objectDecodeError(origin: String?)
        
        public var errorDescription: String? {
            switch self {
            case .statusCodeError(_, let origin, let error):
                return error?.message ?? origin
            case .objectDecodeError(let origin):
                return origin
            default:
                return nil
            }
        }
    }
}

public struct ABCNetworkError: Decodable {
    public let code: Int?
    public let message: String?
    public let timeout: Int?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
        case timeout
    }
}
