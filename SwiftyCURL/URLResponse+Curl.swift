//
//  URLResponse+Curl.swift
//  SwiftyCURL
//
//  Created by Zakk Hoyt on 4/22/18.
//  Copyright © 2018 Zakk Hoyt. All rights reserved.
//

import Foundation


extension URLResponse {
 
    func curlStatusCode() -> Int? {
        guard let httpResponse = self as? HTTPURLResponse else {
            return nil
        }
        return httpResponse.statusCode
    }
    
}

