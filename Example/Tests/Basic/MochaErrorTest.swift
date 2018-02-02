//
//  MochaErrorTest.swift
//  MochaUtilities_Tests
//
//  Created by Gregory Sholl e Santos on 02/02/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class MochaErrorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldntBeNil() {
        //when
        let descriptive = MochaError.descriptive(message: "Message.")
        let error = MochaError.error(error: NSError(domain: "domain",
                                                    code: 0,
                                                    userInfo: nil))
        let http = MochaError.httpResponse(statusCode: 400, data: nil)
        let file = MochaError.fileNotFound
        let implementation = MochaError.notImplemented
        let serialization = MochaError.serialization
        
        //then
        XCTAssertNotNil(descriptive)
        XCTAssertNotNil(error)
        XCTAssertNotNil(http)
        XCTAssertNotNil(file)
        XCTAssertNotNil(implementation)
        XCTAssertNotNil(serialization)
    }
    
    func testEquality() {
        //when
        let descriptive = MochaError.descriptive(message: "Message.")
        let error = MochaError.error(error: NSError(domain: "domain",
                                                    code: 0,
                                                    userInfo: [
                                                        NSLocalizedDescriptionKey:
                                                        "Description."
                                                    ]))
        let http = MochaError.httpResponse(statusCode: 400, data: nil)
        
        //then
        XCTAssertNotEqual(descriptive, .descriptive(message: "Other Message."))
        XCTAssertNotEqual(error, .error(error: NSError(domain: "", code: 1, userInfo: nil)))
        XCTAssertEqual(error, .error(error: NSError(domain: "", code: 23, userInfo: [
                                                                            NSLocalizedDescriptionKey:
                                                                            "Description."])))
        XCTAssertNotEqual(http, .httpResponse(statusCode: 300, data: nil))
        XCTAssertEqual(http, .httpResponse(statusCode: 400, data: "{status:\"NOK\"}".data(using: .utf8)))
        XCTAssertNotEqual(MochaError.fileNotFound, .notImplemented)
        XCTAssertNotEqual(MochaError.notImplemented, .serialization)
        XCTAssertNotEqual(MochaError.serialization, .fileNotFound)
    }
}
