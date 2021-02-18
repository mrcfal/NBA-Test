//
//  MyErrorTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 17/02/21.
//

import XCTest
@testable import NBA_Test

class MyErrorTests: XCTestCase {
    
    var myError: MyError?
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws {
        myError = nil
    }
    
    func test_init_with_message() throws {
        let expectedResult = "This is a message"
        myError = MyError(message: "This is a message")
        let result = try XCTUnwrap(myError?.message)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_init_with_myError() throws {
        let error = MyError(message: "URL not valid")
        myError = MyError(error: error)
        
        let result = try XCTUnwrap(myError?.message)
        let expectedResult = "URL not valid"
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_init_with_generic_error() throws {
        do {
            let _ = try JSONDecoder().decode(TeamModel.self, from: Data())
        } catch let error {
            myError = MyError(error: error)
            XCTAssertNotNil(myError?.message)
        }
    }
}
