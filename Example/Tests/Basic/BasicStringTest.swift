//
//  BasicStringTest.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 09/06/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class BasicStringTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLengthWithEmpty() {
        let empty = ""
        
        XCTAssertEqual(0, empty.length)
    }
    
    func testLengthWithCharactersCount() {
        let someString = "testingString"
        
        XCTAssertEqual(someString.characters.count, someString.length)
    }
    
    func testEmpty() {
        let emptyString = ""
        
        XCTAssertFalse(emptyString.isNotEmpty)
    }
    
    func testNotEmpty() {
        let nonEmptyString = "string"
        
        XCTAssertTrue(nonEmptyString.isNotEmpty)
    }
}
