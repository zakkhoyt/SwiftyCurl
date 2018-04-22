//
//  SwiftyCURLTests.swift
//  SwiftyCURLTests
//
//  Created by Zakk Hoyt on 3/29/18.
//  Copyright © 2018 Zakk Hoyt. All rights reserved.
//

import XCTest
@testable import SwiftyCURL

class SwiftyCURLTests: XCTestCase {
    
    static private let WeatherKey = "4199a667b2597ff5b28f33ec06d6a31b";
    private var goodURL: URL = {
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=37.78&lon=-122.41&APPID=\(WeatherKey)")!
    }()
    
    private var badURL: URL = {
        return URL(string: "http://api.op_TYPO__enweathermap.org/data/2.5/weather?lat=37.78&lon=-122.41&APPID=\(WeatherKey)")!
    }()

    
    private func executeTask(request: URLRequest, completion: @escaping (String?, Error?) -> Void) {
        // We need to use a variable here so that the closure can capture it.
        // We also need to initialized it else compiler will yell at us.
        var task: URLSessionTask! = nil
        task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                let curl = try CURL.curlReport(task: task, data: data, error: error)
                completion(curl, nil)
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
    }
    
    private func executeTask(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let request = URLRequest(url: url)
        executeTask(request: request, completion: completion)
    }
    

    func testGoodURL() {
        let expectation = XCTestExpectation(description: "Input: URL. Waiting for API to return")
        executeTask(url: goodURL) { (curlString, error) in
            XCTAssert(curlString != nil, "Expected curlString to be populated")
            print(curlString!)
            XCTAssert(error == nil, "Expected no error")
            XCTAssert(curlString!.contains("HTTP SUCCESS 200"), "Expected to find string \"HTTP SUCCESS 200\"")
            XCTAssert(curlString!.contains("**** REQUEST ****"), "Expected to find string \"**** REQUEST ****\"")
            XCTAssert(curlString!.contains("-X GET"), "Expected to find string \"-X GET\"")
            XCTAssert(curlString!.contains("**** PAYLOAD ****"), "Expected to find string \"**** PAYLOAD ****\"")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testBadURL() {
        let expectation = XCTestExpectation(description: "Input: URL. Expecting API to return error")
        executeTask(url: badURL) { (curlString, error) in
            
            XCTAssert(error != nil, "Expected a CURL error to be thrown")
            XCTAssert(curlString == nil, "Expected curlString to be nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testHeaders() {
        
        let expectation = XCTestExpectation(description: "Input: URL. Waiting for API to return")
        
        let testHeader1 = "testHeader1"
        let testHeaderValue1 = "testHeaderValue1"
        let testHeader2 = "testHeader2"
        let testHeaderValue2 = "testHeaderValue2"

        var request = URLRequest(url: goodURL)
        request.addValue(testHeaderValue1, forHTTPHeaderField: testHeader1)
        request.addValue(testHeaderValue2, forHTTPHeaderField: testHeader2)
        executeTask(request: request) { (curlString, error) in
            
            XCTAssert(curlString != nil, "Expected curlString to be populated")
            print(curlString!)
            XCTAssert(error == nil, "Expected no error")
            XCTAssert(curlString!.contains("HTTP SUCCESS 200"), "Expected to find string \"HTTP SUCCESS 200\"")
            XCTAssert(curlString!.contains("**** REQUEST ****"), "Expected to find string \"**** REQUEST ****\"")
            XCTAssert(curlString!.contains("-X GET"), "Expected to find string \"-X GET\"")
            XCTAssert(curlString!.contains("**** PAYLOAD ****"), "Expected to find string \"**** PAYLOAD ****\"")
            XCTAssert(curlString!.contains("-H \"testHeader1:testHeaderValue1\""), "Expected Header flag")
            XCTAssert(curlString!.contains("-H \"testHeader2:testHeaderValue2\""), "Expected Header flag")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUserAgent() {
        
        let expectation = XCTestExpectation(description: "Input: URL. Waiting for API to return")
        
        let userAgent = "User-Agent"
        let userAgentValue = "123234345"
        
        var request = URLRequest(url: goodURL)
        
        request.addValue(userAgentValue, forHTTPHeaderField: userAgent)
        executeTask(request: request) { (curlString, error) in
            
            XCTAssert(curlString != nil, "Expected curlString to be populated")
            print(curlString!)
            XCTAssert(error == nil, "Expected no error")
            XCTAssert(curlString!.contains("HTTP SUCCESS 200"), "Expected to find string \"HTTP SUCCESS 200\"")
            XCTAssert(curlString!.contains("**** REQUEST ****"), "Expected to find string \"**** REQUEST ****\"")
            XCTAssert(curlString!.contains("-X GET"), "Expected to find string \"-X GET\"")
            XCTAssert(curlString!.contains("**** PAYLOAD ****"), "Expected to find string \"**** PAYLOAD ****\"")
            XCTAssert(curlString!.contains("-H \"User-Agent:123234345\""), "Expected User Agent")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }


}
