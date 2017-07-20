//
//  HttpHelperTest.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 09/06/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class HttpHelperTest: XCTestCase {
    
    private var mainUrl = "https://httpbin.org"
    
    override func setUp() {
        super.setUp()
    }
    
    func testRequestWithoutUrl() {
        let expect = expectation(description: "HttpHelper returns data through closure.")
        var response : (data: Data?, error: Error?)?
        
        let handler = { (data: Data?, error: Error?) in
            response = (data, error)
            expect.fulfill()
        }
        
        let httpHelper = HttpHelper.builder.completionHandler(handler).build()
        httpHelper.get()
        
        waitForExpectations(timeout: 60) { error in
            XCTAssertTrue(response?.error != nil)
        }
    }
    
    func testGet() {
        let expect = expectation(description: "HttpHelper returns data through closure.")
        var response : (data: Data?, error: Error?)?
        
        let handler = { (data: Data?, error: Error?) in
            response = (data, error)
            expect.fulfill()
        }
        
        let httpHelper = getDefaultBuilder(url: "/get", handler: handler).build()
        httpHelper.get()
        
        waitForExpectations(timeout: 5) { error in
            if let error = response?.error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertTrue(response?.data != nil)
        }
    }
    
    private func getDefaultBuilder(url: String, handler: @escaping HttpCompletionHandler) -> HttpHelper.Builder {
        return HttpHelper.builder.url(mainUrl + url).completionHandler(handler)
    }
}
