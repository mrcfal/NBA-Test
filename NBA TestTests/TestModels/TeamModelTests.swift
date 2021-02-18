//
//  TeamModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 17/02/21.
//

import XCTest
@testable import NBA_Test

class TeamModelTests: XCTestCase {
    var team: TeamModel?
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws {
        team = nil
    }
    
    func test_json_decoding() throws {
        let data = try XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8))
        
        team = try JSONDecoder().decode(TeamModel.self, from: data)
        let unwrappedTeam = try XCTUnwrap(team)
        
        XCTAssertEqual(unwrappedTeam.fullName, "Atlanta Hawks")
        XCTAssertEqual(unwrappedTeam.id, 1)
    }
}
