/******************************************************************************
*
*  (C) 2022 AhnLab Blockchain Company, Inc. All rights reserved.
*  Any part of this source code can not be copied with any method without
*  prior written permission from the author or authorized person.
*
******************************************************************************/

import Foundation

extension URLSession {
    public func invoke<Item: Decodable>(with urlRequest: URLRequest?, completion: ((Result<Item, NetworkError.Response>) -> Void)?) {
        
        guard let request = urlRequest else {
            let error = NetworkError.Response.urlError(url: urlRequest?.url?.absoluteString)
            completion?(.failure(error))
            return
        }
        
        self.dataTask(with: request) { data, response, error in
            if let error = error {
                completion?(.failure(NetworkError.Response.serverError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NetworkError.Response.invalidHttpResponse
                completion?(.failure(error))
                return
            }
            
            guard let responseData = data else {
                completion?(.failure(NetworkError.Response.emptyData))
                return
            }
            
            let origin = String(bytes: responseData, encoding: .utf8)
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                let status = response.statusCode
                let errorObject = try? JSONDecoder().decode(ABCNetworkError.self, from: responseData)
                let error = NetworkError.Response.statusCodeError(status: status, origin: origin, error: errorObject)
                completion?(.failure(error))
                return
            }
            
            do {
                let decodeItem = try JSONDecoder().decode(Item.self, from: responseData)
                completion?(.success(decodeItem))
            } catch {
                completion?(.failure(NetworkError.Response.objectDecodeError(origin: origin)))
            }
        }
        .resume()
    }
    
    public func invoke(with urlRequest: URLRequest?, completion: ((Result<Void, NetworkError.Response>) -> Void)?) {
        
        guard let request = urlRequest else {
            let error = NetworkError.Response.urlError(url: urlRequest?.url?.absoluteString)
            completion?(.failure(error))
            return
        }
        
        self.dataTask(with: request) { data, response, error in
            if let error = error {
                completion?(.failure(NetworkError.Response.serverError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NetworkError.Response.invalidHttpResponse
                completion?(.failure(error))
                return
            }
            
            guard let responseData = data else {
                completion?(.failure(NetworkError.Response.emptyData))
                return
            }
            
            let origin = String(bytes: responseData, encoding: .utf8)
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                let status = response.statusCode
                let errorObject = try? JSONDecoder().decode(ABCNetworkError.self, from: responseData)
                let error = NetworkError.Response.statusCodeError(status: status, origin: origin, error: errorObject)
                completion?(.failure(error))
                return
            }
            
            completion?(.success(()))
        }
        .resume()
    }
}
