//
//  ResultTest.swift
//  MochaUtilities_Tests
//
//  Created by Gregory Sholl e Santos on 02/02/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class ResultTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldNotBeNil() {
        //when
        let success = Result<Data?>.success(nil)
        let failure = Result<Data?>.failure(MochaError.notImplemented)
        
        //then
        XCTAssertNotNil(success)
        XCTAssertNotNil(failure)
    }
    
    func testResultValue() {
        //when
        let stringResult = stringFor(success: true)
        let errorResult = stringFor(success: false)
        
        //then
        switch stringResult {
        case .success(let string):
            XCTAssert(string == "Success.")
        default:
            XCTAssert(false)
        }
        
        switch errorResult {
        case .failure(let error):
            XCTAssert(error == MochaError.descriptive(message: "Wanted failed result."))
        default:
            XCTAssert(false)
        }
    }
    
    func testChangeResultType() {
        //when
        let result = stringFor(success: true).map { $0.data(using: .utf8) }
        
        //then
        switch result {
        case .success(let data):
            XCTAssertNotNil(data)
            XCTAssert(String(data: data!, encoding: .utf8) == "Success.")
        default:
            XCTAssert(false)
        }
    }
    
    private func stringFor(success: Bool) -> Result<String> {
        if success {
            return .success("Success.")
        } else {
            return .failure(MochaError.descriptive(message: "Wanted failed result."))
        }
    }
}
