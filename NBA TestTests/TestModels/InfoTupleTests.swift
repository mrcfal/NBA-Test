//
//  InfoTupleTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class InfoTupleTests: XCTestCase {
    
    var infoTuple: InfoTuple!
    var array: [InfoTuple]!
    
    override func setUpWithError() throws {
        infoTuple = (boldKey: "key0", value: "zero")
        array = [infoTuple]
    }
    
    override func tearDownWithError() throws {
        infoTuple = nil
        array = nil
    }
    
    func test_subscript() {
        XCTAssertEqual(array["key0"], "zero")
    }
    
    func test_subscript_with_not_existing_key() {
        XCTAssertNil(array["not_existing_key"])
    }
    
    func test_subscript_when_saving_same_key_twice() {
        array["key0"] = "newValue"
        
        XCTAssertEqual(array["key0"], "newValue")
    }
    
    func test_subscript_remove_item() {
        array["key0"] = nil
        XCTAssertNil(array["key0"])
    }
}
