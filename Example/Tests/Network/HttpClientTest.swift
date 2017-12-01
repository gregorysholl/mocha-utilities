//
//  HttpClientTest.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 09/06/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class HttpClientTest: XCTestCase {
    
    private var mainUrl = "https://httpbin.org"
    
    override func setUp() {
        super.setUp()
    }
    
    func testRequestWithoutUrl() {
        let expect = expectation(description: "HttpHelper returns data through closure.")
        var response : Result<Data>!
        
        let handler = { (result: Result<Data>) in
            response = result
            expect.fulfill()
        }
        
        let httpHelper = HttpClient.Builder(build: {
            $0.responseHandler = handler
        }).build()
        httpHelper.get()
        
        waitForExpectations(timeout: 60) { error in
            if error != nil {
                XCTAssert(false)
            }
            
            switch response! {
            case .failure(let error):
                switch error {
                case .descriptive(_):
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            case .success(_):
                XCTAssert(false)
            }
        }
    }
    
    func testGet() {
        let expect = expectation(description: "HttpHelper returns data through closure.")
        var response : Result<Data>!
        
        let handler = { (result: Result<Data>) in
            response = result
            expect.fulfill()
        }
        
        let httpHelper = getDefaultBuilder(url: "/get", handler: handler).build()
        httpHelper.get()
        
        waitForExpectations(timeout: 5) { error in
            switch response! {
            case .failure(_):
                XCTAssert(false)
            case .success(_):
                XCTAssert(true)
            }
        }
    }
    
    private func getDefaultBuilder(url: String, handler: @escaping HttpClient.Handler) -> HttpClient.Builder {
        return HttpClient.Builder(build: {
            $0.url = mainUrl + url
            $0.responseHandler = handler
        })
    }
}
