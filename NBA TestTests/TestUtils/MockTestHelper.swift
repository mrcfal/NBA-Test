//
//  MockTestHelper.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation
@testable import NBA_Test

class MockTestHelper: TestHelper {
    var isSetCalled = false
    var onCalled: ((String, String)->Void)?

    func onSet() {
        isSetCalled = true
    }
    
    func onCalled(function: String, file: String) {
        onCalled?(function, file)
    }
}
