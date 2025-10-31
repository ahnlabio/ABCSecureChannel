//
//  File.swift
//  ABCSecureChannel
//
//  Created by ABCElio on 10/27/25.
//

import Foundation

public enum LogStyle {
    case prettyJson, string, none
}

public enum ABCNetworkLogger {
    public static func printRequestLog(_ request: URLRequest, logStyle: LogStyle) {
        #if DEBUG
        var body: Any?
        let header = request.allHTTPHeaderFields?.prettyPrintedJSONString ?? "nil"
        if let data = request.httpBody {
            switch logStyle {
            case .prettyJson:
                body = data.asPrettyJsonString()
            case .string:
                body = String(data: data, encoding: .utf8)
            case .none:
                body = nil
            }
        }
        let log = """
        📣 Request Call 📣
            - url: \(request.url?.absoluteString ?? "")
            - header: \(header)
            - method: \(request.httpMethod ?? "")
            - body: \(body ?? "")
        """
        print(log)
        #endif
    }
    
    public static func printResponseLog(_ response: HTTPURLResponse, data: Data?, logStyle: LogStyle) {
        #if DEBUG
        let header = response.allHeaderFields.prettyPrintedJSONString
        var body: Any?
        if let data = data {
            switch logStyle {
            case .prettyJson:
                body = data.asPrettyJsonString()
            case .string:
                body = String(data: data, encoding: .utf8)
            case .none:
                body = nil
            }
        }
        let log = """
         🔵 Response Successful 🔵
             - url: \(response.url?.absoluteString ?? "")
             - header: \(header)
             - statusCode: \(response.statusCode)
             - body: \(body ?? "nil")
         """
        print(log)
        #endif
    }
    
    public static func printResponseFailLog(_ response: HTTPURLResponse, data: Data? = nil, logStyle: LogStyle) {
        #if DEBUG
        let header = response.allHeaderFields.prettyPrintedJSONString
        var body: Any?
        if let data = data {
            switch logStyle {
            case .prettyJson:
                body = data.asPrettyJsonString()
            case .string:
                body = String(data: data, encoding: .utf8)
            case .none:
                body = nil
            }
        }
        let log = """
         🔴 Response Failed 🔴
             - url: \(response.url?.absoluteString ?? "")
             - header: \(header)
             - statusCode: \(response.statusCode)
             - body: \(body ?? "nil")
         """
        print(log)
        #endif
    }
}

fileprivate extension Dictionary {
    var prettyPrintedJSONString: String {
        guard !isEmpty else { return "nil" }
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        return String(data: jsonData ?? Data(), encoding: .utf8) ?? "nil"
    }
}

fileprivate extension Data {
    
    func asPrettyJsonString() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self) else {
            return String(data: self, encoding: .utf8)
        }
        
        let prettyJsonData = try? JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted])
        guard let prettyJsonData else { return .none }
        return String(data: prettyJsonData, encoding: .utf8)
    }
}
