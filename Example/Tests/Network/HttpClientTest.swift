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
            $0.handler = handler
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
    }

    func testPost() {
        let expect = expectation(description: "HttpHelper returns data through closure.")
        var response : Result<Data>!

        let handler = { (result: Result<Data>) in
            response = result
            expect.fulfill()
        }

        let builder = getDefaultBuilder(url: "/post", handler: handler)
        builder.parameters = ["obj1": "content1", "obj2": "content2"]
        builder.contentType = .json
        builder.build().post()

        waitForExpectations(timeout: 5) { error in
            switch response! {
            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                    guard let jsonDict = json as? [String: Any] else {
                        XCTAssert(false, "'json' is not a dictionary")
                        return
                    }

                    print("\(jsonDict)")
                    XCTAssert(true)
                } catch let jsonError {
                    XCTAssert(false, jsonError.localizedDescription)
                }
            }
        }
    }
    
    private func getDefaultBuilder(url: String, handler: @escaping HttpClient.Handler) -> HttpClient.Builder {
        return HttpClient.Builder(build: {
            $0.url = mainUrl + url
            $0.handler = handler
        })
    }
}
