//
//  CURLLog.swift
//  HatchKit
//
//  Created by Zakk Hoyt on 11/11/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation

public struct CURL {
    
    public enum CURLError: Error {
        case noRequest
        case noResponse
        case noHttpResponse
    }

    static public func curlReport(task: URLSessionTask,
                                   data: Data?,
                                   error: Error? = nil) throws -> String {
        guard let request = task.originalRequest else {
            throw CURLError.noRequest
        }
        
        guard let response = task.response else {
            throw CURLError.noResponse
        }
        
        let statusCode = response.curlStatusCode() ?? 0
        return curlReportFrom(request: request, response: response, data: data , statusCode: statusCode)
    }

    private static func curlReportFrom(request: URLRequest,
                                       response: URLResponse,
                                       data: Data?,
                                       statusCode: Int,
                                       verbose: Bool = false) -> String {
        let titleString: String = {
            if isError(status: statusCode) {
                return "\n**************** HTTP ERROR \(statusCode) **********************"
            } else {
                return "\n**************** HTTP SUCCESS \(statusCode) **********************"
            }
        }()
        
        let requestString: String = {
            return """
            **** REQUEST ****
            \(request.curlCommand())
            """
        }()

        let payloadString: String = {
            return """
            **** PAYLOAD ****
            \(data?.curlRepresentation(response: response) ?? "")
            """
        }()
        
        let suffixString: String = "****************************************************"
        
        let output = """
        \(titleString)
        \(requestString)
        \(payloadString)
        \(suffixString)
        """
        return output
    }
    
    private static func isError(status: Int) -> Bool {
        return status < 200 || status >= 300
    }
}


