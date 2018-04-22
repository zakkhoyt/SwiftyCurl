//
//  URLRequest+Curl.swift
//  SwiftyCURL
//
//  Created by Zakk Hoyt on 4/22/18.
//  Copyright © 2018 Zakk Hoyt. All rights reserved.
//

import Foundation

private struct CurlParameters {
    static let request = " -X %@ \"%@\""
    static let command = "curl"
    static let verbosity = " --verbose"
    static let header = " -H \"%@:%@\""
    static let data = " -d '%@'"
}


public extension URLRequest {
    func curlCommand(verbose: Bool = false) -> String {
        let verboseString = verbose ? CurlParameters.verbosity : ""
        
        let command = CurlParameters.command + verboseString
        
        var headerString = ""
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                if key != "Accept-Language" {
                    headerString += String(format: CurlParameters.header, key, value)
                }
            }
        }
        
        let commandWithHeaders = command + headerString
        var dataString = ""
        if let httpBody = self.httpBody {
            if let d = String(data: httpBody, encoding: String.Encoding.utf8) {
                dataString = String(format: CurlParameters.data, d)
            }
        }
        var request = ""
        if let httpMethod = self.httpMethod,
            let urlString = self.url?.absoluteString {
            request = String(format: CurlParameters.request, httpMethod, urlString)
        }
        return commandWithHeaders + dataString + request
    }
}

