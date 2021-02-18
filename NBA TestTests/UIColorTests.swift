//
//  UIColorTests.swift
//  NBA TestUITests
//
//  Created by Marco Falanga on 17/02/21.
//

import XCTest
@testable import NBA_Test

class UIColorTests: XCTestCase{

    var color: UIColor!
    
    override func setUpWithError() throws {
        color = UIColor()
    }

    override func tearDownWithError() throws {
        color = nil
    }
    
    func test_myBlue_is_not_nil() {
        color = .myBlue
        
        XCTAssertNotNil(color)
    }
}
