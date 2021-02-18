//
//  HelpersTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 17/02/21.
//

import XCTest

@testable import NBA_Test

class HelpersTests: XCTestCase {
    var error: MyError?
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws {
        error = nil
    }
    
    func test_getLogo_throws_error_when_invalid_url() throws {
        var team = try teamBuilder()
        team.abbreviation = "%%%$$"
        
        XCTAssertThrowsError(try Helpers.getTeamLogoUrl(team: team))
    }
    
    func test_getLogo_throws_error_and_error_is_expected() throws {
        let team = try teamBuilder()
        
        do {
            let _ = try Helpers.getTeamLogoUrl(team: team, hostname: "invalid_url")
        } catch let error {
            if let error = error as? MyError {
                XCTAssertEqual("URL not valid", error.message)
            }
        }
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
