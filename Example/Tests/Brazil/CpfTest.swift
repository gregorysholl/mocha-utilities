//
//  CpfTest.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 11/06/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import MochaUtilities

class CpfTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUnmaskWithNil() {
        XCTAssertEqual("", CpfUtil.unmask(nil))
    }
    
    func testUnmask() {
        XCTAssertEqual("00000000000", CpfUtil.unmask("000.000.000-00"))
    }
    
    func testMaskWithWrongLenght() {
        XCTAssertEqual("", CpfUtil.mask("00000"))
    }
    
    func testMask() {
        XCTAssertEqual("000.000.000-00", CpfUtil.mask("00000000000"))
    }
    
    func testMaskedWithWrongLength() {
        XCTAssertFalse(CpfUtil.isMasked("000.00.000-00"))
    }
    
    func testMaskedWithLetters() {
        //since it only checks if the mask is applied, it can contain letters inside
        XCTAssertTrue(CpfUtil.isMasked("000.000.0a0-00"))
    }
    
    func testMaskedWithWrongIndexes() {
        XCTAssertFalse(CpfUtil.isMasked("00.0000.00-000"))
    }
    
    func testMaskedPass() {
        XCTAssertTrue(CpfUtil.isMasked("000.000.000-00"))
    }
    
    func testValidWithLetters() {
        XCTAssertFalse(CpfUtil.isValid("000.000.0a0-00"))
    }
    
    func testValidWithWrongLength() {
        XCTAssertFalse(CpfUtil.isValid("00.0.00-0"))
    }
    
    func testInvalid() {
        XCTAssertFalse(CpfUtil.isValid("000.000.000-01"))
    }
    
    func testValid() {
        XCTAssertTrue(CpfUtil.isValid("000.000.000-00"))
    }
}
